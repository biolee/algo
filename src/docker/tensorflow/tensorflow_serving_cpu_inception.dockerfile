FROM biolee/tensorflow_serving_dev:latest

MAINTAINER li yanan <liyananfamily@gmail.com>

RUN curl -O http://download.tensorflow.org/models/image/imagenet/inception-v3-2016-03-01.tar.gz && \
	tar xzf inception-v3-2016-03-01.tar.gz && \
	inception_saved_model --checkpoint_dir=inception-v3 --output_dir=/tmp/inception-export

CMD ["tensorflow_model_server","--port=9000","--model_base_path=/tmp/inception-export","&>", "inception_log","&"]