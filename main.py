import datetime


def define_env(env):

    @env.filter
    def add_week(d, dw):
        return d + datetime.timedelta(weeks=dw)

    @env.filter
    def add_day(d, dd):
        return d + datetime.timedelta(days=dd)

    @env.filter
    def dow(x, d):
        dow = x.isoweekday()
        return x - datetime.timedelta(days=(dow - 1)) + datetime.timedelta(days=d)

    @env.filter
    def euro_day(x):
        return x.strftime("%d.%m.%Y")

    @env.filter
    def ld(x, week):
        x = add_week(x, week)
        x = dow(x, 4)  # Friday
        return euro_day(x)


def main():
    print("Hello !")


if __name__ == "__main__":
    main()
