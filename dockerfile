FROM python:3.11-slim AS builder

RUN apt-get update && apt-get install -y make ocaml opam && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

RUN opam init -y --disable-sandboxing && \
    opam install -y ocamlfind ounit2 && \
    . /root/.opam/opam-init/init.sh > /dev/null 2>&1 && \
    make

RUN python3 -m venv /opt/venv && \
    . /opt/venv/bin/activate && \
    pip install --upgrade pip && \
    pip install -r app/requirements.txt

FROM gcr.io/distroless/python3

COPY --from=builder /app /app
COPY --from=builder /opt/venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

WORKDIR /app

EXPOSE 8080

CMD ["gunicorn", "-b", "0.0.0.0:8080", "main:app"]