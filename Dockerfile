FROM registry.access.redhat.com/ubi8/ubi-minimal:8.10-1018

RUN --mount=type=tmpfs,destination=/tmp/cache\
    --mount=type=cache,target=/tmp/cache/yum\
    --mount=type=tmpfs,destination=/tmp/.cache\
    --mount=type=cache,target=/tmp/.cache\
    microdnf update -y && microdnf install -y python3 python3-pip && python3 -m pip install --upgrade pip
WORKDIR assisted_event_scrape/

COPY requirements.txt .
RUN --mount=type=tmpfs,destination=/tmp/.cache\
    --mount=type=cache,target=/tmp/.cache\
    python3 -m pip install -I -r requirements.txt vcversioner

COPY . .
RUN --mount=type=tmpfs,destination=/tmp/.cache\
    python3 -m pip install .

ENTRYPOINT ["events_scrape"]
