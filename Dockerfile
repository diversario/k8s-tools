FROM diversario/toolbox:0.0.2

COPY ./run.sh /run.sh

ENTRYPOINT /run.sh $@