import random, datetime as dt, sys
random.seed(42)
out = []
base_new = dt.datetime(2026, 11, 1)
base_old = dt.datetime(2026, 9, 1)
def emit(i, route, when):
    tid = f"X{i:05d}"
    ts = int(when.replace(tzinfo=dt.timezone.utc).timestamp())
    out.append(f'HSET trip:{tid} trip_id {tid} route_id {route} started_at "{when:%Y-%m-%d %H:%M}" status completed')
    out.append(f'ZADD route:{route}:trips {ts} {tid}')
for r in range(1, 101):
    out.append(f'HSET route:{r} route_id {r} route_name "Rute {r}"')
i = 0
for _ in range(1000):
    emit(i, 12, base_new + dt.timedelta(minutes=random.randint(0, 40*24*60))); i += 1
for _ in range(500):
    emit(i, 12, base_old + dt.timedelta(minutes=random.randint(0, 59*24*60))); i += 1
while i < 20000:
    r = random.choice([x for x in range(1, 101) if x != 12])
    emit(i, r, base_old + dt.timedelta(minutes=random.randint(0, 100*24*60))); i += 1
sys.stdout.write("\n".join(out) + "\n")
