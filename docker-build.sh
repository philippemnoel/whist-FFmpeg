./build-docker-image.sh $1
container_id=$(docker run -it -d ffmpeg-builder-ubuntu$1)
echo "Container id is ${container_id}"
LIB_LOC=/usr/local/lib
LIBS=(libavcodec libavdevice libavfilter libavformat libavutil libswresample libpostproc libswscale)

for lib in "${LIBS[@]}"; do
    echo "Copying over $lib"
    
    # echo "Command is: docker cp ${containter_id}:${LIB_LOC}/${lib}.so docker-builds"
    docker exec ${container_id} /bin/bash -c "cp ${LIB_LOC}/${lib}* /docker-builds"
done

rm -r docker-builds
docker cp ${container_id}:/docker-builds .

docker container kill $container_id