#/bin/sh

#docker
docker build -t registry.cn-hangzhou.aliyuncs.com/kk/kk-nginx:latest .

if [ $? -ne 0 ]; then
	echo -e "[FAIL] docker build -t registry.cn-hangzhou.aliyuncs.com/kk/kk-nginx:latest ."
	exit
fi

docker push registry.cn-hangzhou.aliyuncs.com/kk/kk-nginx:latest

if [ $? -ne 0 ]; then
	echo -e "[FAIL] docker push registry.cn-hangzhou.aliyuncs.com/kk/kk-nginx:latest"
	exit
fi
