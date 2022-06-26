"""
Just an example for a plotting script, that can plot either a light or a dark themed plot.
"""
from argparse import ArgumentParser
import numpy as np
import matplotlib.pyplot as plt


parser = ArgumentParser()

parser.add_argument('--theme',
                    default='light',
                    nargs='?',
                    choices=['light', 'dark'],
                    help="""The theme for the plots. Choose from 'light' and 'dark'
                    \n(default: %(default)s)
                    """
)


if __name__ == '__main__':
    args = parser.parse_args()

    if args.theme == 'dark':
        plt.style.use('plots/darkmode.mplstyle')

    fig, ax = plt.subplots(1,1, constrained_layout=True)

    L = 6
    x = np.linspace(0, L)
    ncolors = len(plt.rcParams['axes.prop_cycle'])
    shift = np.linspace(0, L, ncolors, endpoint=False)
    for s in shift:
        ax.plot(x, np.sin(x + s), 'o-', label=f'{s}')

    ax.set_xlabel('x-axis')
    ax.set_ylabel('y-axis')
    ax.set_xscale('log')
    # ax.legend()
    ax.grid()
    ax.set_title('test')
    fig.suptitle('TEST')

    plt.savefig("plots/plot.pdf")
