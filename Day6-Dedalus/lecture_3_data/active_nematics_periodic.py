"""Active nematics in a 2D periodic domain."""

import numpy as np
import dedalus.public as d3
import logging
logger = logging.getLogger(__name__)


# Discretization parameters
L = 8 * np.pi
N = 128
dealias = 2
dtype = np.float64
timestepper = d3.RK443
initial_dt = 1e-2
safety = 0.5
stop_sim_time = 15
snapshots_dt = 0.1
scalars_dt = 0.1

# Physical parameters
eta = 1     # Relative viscosity
gamma = 0.1 # Friction
alpha = -8  # Dipole strength
ks = 10     # Spring constant of alignment field
S0 = 1      # Base order-parameter for spring field

# Domain
coords = d3.CartesianCoordinates('x', 'y')
dist = d3.Distributor(coords, dtype=dtype)
xbasis = d3.RealFourier(coords['x'], size=N, bounds=(-L/2, L/2), dealias=dealias)
ybasis = d3.RealFourier(coords['y'], size=N, bounds=(-L/2, L/2), dealias=dealias)

# Fields
P = dist.Field(name='P', bases=(xbasis,ybasis))                        # Pressure
u = dist.VectorField(coords, name='u', bases=(xbasis,ybasis))          # Fluid Velocity
Q = dist.TensorField((coords,coords), name='Q', bases=(xbasis,ybasis)) # 2nd order Q-tensor (symmetric)
H = dist.TensorField((coords,coords), name='H', bases=(xbasis,ybasis)) # Alignment field
tau_p = dist.Field(name='tau_p')

# Problem
problem = d3.IVP([u, P, Q, H, tau_p], namespace=locals())
problem.add_equation("H - lap(Q) - ks * S0**2 * Q = -ks * Trace(Q@Q) * Q")
problem.add_equation("-grad(P) + eta*lap(u) - gamma*u + alpha*div(Q) = -div(Q@H - H@Q)")
problem.add_equation("dt(Q) - H = -u@grad(Q) + Q@grad(u) + (grad(u).T)@Q - 2*Q*Trace(Q@grad(u))")
problem.add_equation("div(u) + tau_p = 0")
problem.add_equation("integ(P) = 0")

# Solver
solver = problem.build_solver(timestepper)
solver.stop_sim_time = stop_sim_time

# Initial conditions
I = dist.IdentityTensor(coords)
Q.fill_random(layout='g', seed=3)
Q.low_pass_filter(shape=(16, 16))
Q['g'] *= 1e-3
Q['g'][0,0] += 0.5
Q_sym = (Q + Q.T)/2
Q['g'] = Q_sym.evaluate()['g']

# Analysis
snapshots = solver.evaluator.add_file_handler('periodic_data/snapshots', sim_dt=snapshots_dt, max_writes=1, parallel='gather')
snapshots.add_task(u)
snapshots.add_task(-d3.div(d3.skew(u)), name='vorticity')
snapshots.add_task(Q)
snapshots.add_task(d3.Trace(Q @ Q.T), name='I2(Q)')

scalars = solver.evaluator.add_file_handler('periodic_data/scalars', sim_dt=scalars_dt, parallel='gather')
scalars.add_task(d3.Average(u@u/2), name='KE')

# CFL
cfl = d3.CFL(solver, initial_dt=initial_dt, cadence=10, safety=safety, max_change=1.5,
             min_change=0.5, max_dt=initial_dt, threshold=0.05)
cfl.add_velocity(u)

# Main loop
try:
    logger.info('Starting main loop')
    while solver.proceed:
        # Step
        timestep = cfl.compute_timestep()
        solver.step(timestep)
        # Symmetrize Q
        Q['c'] = Q_sym.evaluate()['c']
        # Log
        if (solver.iteration - 1) % 10 == 0:
            logger.info('Iteration=%i, Time=%e, dt=%e' %(solver.iteration, solver.sim_time, timestep))
except:
    logger.error('Exception raised, triggering end of main loop.')
    raise
finally:
    solver.log_stats()
