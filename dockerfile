FROM python:3.11-slim

RUN apt-get update && apt-get install -y make ocaml opam && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

RUN opam init -y --disable-sandboxing && \
    opam install -y ocamlfind ounit2 && \
    . /root/.opam/opam-init/init.sh > /dev/null 2>&1 && \
    make

RUN pip install -r app/requirements.txt

EXPOSE 8080

CMD ["python3", "app/main.py"]