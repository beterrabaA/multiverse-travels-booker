FROM crystallang/crystal:1.8.2-alpine

WORKDIR /api

COPY ./shard.yml ./shard.lock /api/

RUN shards install

COPY . /api/

EXPOSE 3000

CMD [ "crystal", "src/api.cr"	 ]

