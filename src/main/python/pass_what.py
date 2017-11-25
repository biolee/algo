class A:
    def __init__(self, s):
        self.v = s


def pass_pointer1(p1, p2):
    p1.v = "changed"
    p2 = A("changed")


def pass_pointer2(p1, p2):
    p1["v"] = "changed"
    p2 = {"v": "changed"}


if __name__ == '__main__':
    a1 = A("unchanged")
    a2 = A("unchanged")

    pass_pointer1(a1, a2)

    print(a1.v)  # changed
    print(a2.v)  # unchanged

    a1 = {"v": "unchanged"}
    a2 = {"v": "unchanged"}

    pass_pointer2(a1, a2)

    print(a1["v"])  # changed
    print(a2["v"])  # changed
