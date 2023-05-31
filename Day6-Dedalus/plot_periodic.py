"""
Plot planes from joint analysis files.

Usage:
    plot_snapshots.py <files>... [--output=<dir>]

Options:
    --output=<dir>  Output directory [default: ./frames]

"""

import h5py
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

from dedalus.extras import plot_tools


def main(filename, start, count, output):
    """Save plot of specified tasks for given range of analysis writes."""

    # Plot settings
    tasks = [('vorticity', tuple(), (0,0)),
             ('Q', (0,0), (1,0)),
             ('Q', (0,1), (1,1)),
             ('Q', (1,1), (1,2))]
    scale = 3
    dpi = 200
    title_func = lambda sim_time: 't = {:.3f}'.format(sim_time)
    savename_func = lambda write: 'write_{:06}.png'.format(write)

    # Layout
    nrows, ncols = 2, 3
    image = plot_tools.Box(1, 1)
    pad = plot_tools.Frame(0.2, 0.1, 0, 0)
    margin = plot_tools.Frame(0.2, 0.1, 0, 0)

    # Create multifigure
    mfig = plot_tools.MultiFigure(nrows, ncols, image, pad, margin, scale)
    fig = mfig.figure
    # Plot writes
    with h5py.File(filename, mode='r') as file:
        for index in range(start, start+count):
            for task, comp, subax in tasks:
                # Build subfigure axes
                axes = mfig.add_axes(*subax, [0, 0, 1, 1])
                # Call plot bot
                dset = file['tasks'][task]
                image_axes = (1 + len(comp), 2 + len(comp))
                data_slices = (index,) + comp + (slice(None), slice(None))
                title = task + str(comp)*(len(comp) != 0)
                plot_tools.plot_bot(dset, image_axes, data_slices, title=title, even_scale=True, visible_axes=False, axes=axes)
            # Add time title
            title = title_func(file['scales/sim_time'][index])
            title_height = 1 - 0.5 * mfig.margin.top / mfig.fig.y
            fig.suptitle(title, x=0.45, y=title_height, ha='left')
            # Save figure
            savename = savename_func(file['scales/write_number'][index])
            savepath = output.joinpath(savename)
            fig.savefig(str(savepath), dpi=dpi)
            fig.clear()
    plt.close(fig)


if __name__ == "__main__":

    import pathlib
    from docopt import docopt
    from dedalus.tools import logging
    from dedalus.tools import post
    from dedalus.tools.parallel import Sync

    args = docopt(__doc__)

    output_path = pathlib.Path(args['--output']).absolute()
    # Create output directory if needed
    with Sync() as sync:
        if sync.comm.rank == 0:
            if not output_path.exists():
                output_path.mkdir()
    post.visit_writes(args['<files>'], main, output=output_path)

