pwd=$(pwd)
#echo $pwd
sudo docker run -d -i -p 5000:5000 -v $pwd/rosamia-txt:/app/rosamia-txt rasa_nlu start -c ./rosamia-txt/config_mitie_docker.json   --server_model_dirs=/app/rosamia-txt/models/model_20170929-043427
