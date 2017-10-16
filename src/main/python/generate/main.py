import time

a = 10


def generate_g():
    while True:
        time.sleep(1)
        print(a)
        yield a


if __name__ == '__main__':
    g = generate_g()
    for j in g:
        a = 10 + j;
