#   python functions to be aliased in .alias and called as needed
from math import sqrt


def factor(n, factors=[]):
    """ This function returns the prime factorization.

    Args:
        n: the number to be factored
    """

    n = int(n)
    if n < 1: print('invalid input')

    while not n%2:
        factors.append(2)
        n //= 2

    for d in range(3, int(sqrt(n)), 2):

        while not n%d:
            factors.append(d)
            n //= d

    if n != 1:
        factors.append(n)

    print(' '.join([str(i) for i in factors]))


def fibonacci(term_num):
    """ This function returns the term_num'th number
        in the fibonacci sequence (starting at 1).

    Args:
        term_num: the term number in the sequence to produce.
    """

    term_num = int(term_num)
    a, b = 0, 1
    for i in range(1, term_num):
        a, b = b, b+a

    print(str(b))


def regression(csv_file_path, delim=","):
    """ Runs an OLS regression.

    This regresses the last column on all other non-index columns,
    and prints a summary.

    Args:
        csv_file_path: the filepath of the csv data file, organized
            so that the endogenous variable is the last column.
    """

    import pandas as pd
    from statsmodels.api import OLS as ols
    df = pd.read_csv(csv_file_path, delim).dropna()
    X = df[df.columns[1:-1]].astype(int)
    X['const'] = 1
    y = df[df.columns[-1]]
    print(ols(y, X).fit(const=True).summary())


def permutations(*l):
    def helper(l , start=[], results=[]):
        if len(l) < 2:
            results.append(start + l)
        else:
            for _ in range(len(l)):
                helper(l[1:], start+[l[0]])
                l = l[1:] + [l[0]]
        return results

    for el in helper(list(l)): print(el)
