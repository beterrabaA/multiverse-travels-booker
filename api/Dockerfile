FROM crystallang/crystal

WORKDIR /api

COPY ./shard.yml ./shard.lock /api/

RUN shards install

COPY . /api/

RUN crystal build -o bin/api src/api.cr

ENTRYPOINT [ "bin/api" ]

EXPOSE 3000


