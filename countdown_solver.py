from itertools import permutations, product
from operator import add, mul, sub, floordiv
from random import randint, sample
import pdb

""" This file contains functions to solve the countdown numbers game.

    The game follows simple rules. Given a target value and six numbers,
    use arithmetic operations to calculate the target. You do not need
    to use all the numbers. Numbers are either small {1 to 10} or large
    {25, 50, 75, 100}.

    Example:
        Target: 29
        Numbers: 1, 2, 9, 10, 25, 75
        Solution: 29 = 2 + 9 x 75 ÷ 25
"""

def get_target():
    return randint(300, 1350)

def get_nums():
    nb = randint(0, 4)
    return sample([25, 50, 75, 100], nb) + [randint(1, 10) for _ in range(6-nb)]

class ArithmeticNode:
    def __init__(self, value, op_str, operation, left, right):
        self.value = value
        self.op_str = op_str
        self.operation = operation
        self.left = left
        self.right = right

    def get_value(self, left=None, right=None):
        l = left or self.left.get_value()
        r = right or self.right.get_value()

        if not l and r:
            return None

        if self.operation == floordiv and (r == 0 or l % r != 0):
            return None

        return self.operation(l, r)

    def __repr__(self):
        return "({} {} {})".format(self.left, self.op_str, self.right)

    def search_value(self, val):
        l, lv, ld = self.left.search_value(val)
        r, rv, rd = self.right.search_value(val)

        if lv == val: return (l, lv, ld)
        if rv == val: return (r, rv, rd)

        mv = self.get_value(lv, rv)

        if mv == val:
            pdb.set_trace()
            return (str(self), mv, 0)

        md = abs(mv - val) if mv else None

        if ld and ld <= (md or ld) and ld <= (rd or ld):
            return (l, lv, ld)
        if rd and rd <= (ld or rd) and rd <= (md or rd):
            return (r, rv, rd)
        if md and md <= (ld or md) and md <= (rd or md):
            return (str(self), mv, md)
        print("WTF")
        return [None]*3

class ArithmeticLeaf(ArithmeticNode):
    def get_value(self, l=None, r=None):
        return self.value

    def __repr__(self):
        return "{}".format(self.value)

    def search_value(self, val):
        return (str(self), self.get_value(), abs(self.get_value() - val))

def get_all_trees(numbers, operations):
    if operations:
        trees = []
        for i in range(len(operations)):
            l = get_all_trees(numbers[:i+1], operations[:i])
            r = get_all_trees(numbers[i+1:], operations[i+1:])
            op = operations[i]

            for left, right in product(l, r):
                trees.append(ArithmeticNode(None, *op, left, right))

        return trees

    return [ArithmeticLeaf(numbers[0], *[None]*4)]


def get_operators_lists(n=5):
    return product(
        [("+", add), ("*", mul), ("-", sub), ("/", floordiv)],
        repeat=n,
    )


def get_number_lists(numbers):
    return permutations([int(n) for n in numbers])


def numbers(target, numbers):
    print("Target: {}".format(target))
    print("Numbers: {}".format(numbers))

    target = int(target)
    closest = ("", 0, target)

    for number_list in get_number_lists(numbers):
        for operator_list in get_operators_lists(len(number_list)-1):
            for tree in get_all_trees(number_list, operator_list):
                s, v, d = tree.search_value(target)
                if v == target:
                    print("{} = {}, {} away from {}".format(s, v, d, target))
                    return True
                elif d and (d < closest[2]):
                    closest = (s, v, d)

    print("{} = {}, {} away from {}".format(*closest, target))
    return False
