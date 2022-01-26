#!/bin/bash
IMAGE_SIZE=224
GRAPH=/tf_files/retrained_graph.pb
OUTPUT=/tf_files/sandwich.tflite
OUTPUT_LABELS=/tf_files/retrained_labels.txt
ARCHITECTURE=mobilenet_0.50_${IMAGE_SIZE}
TRAINING_STEPS=10000
LEARNING_RATE=0.002
# TF_HUB_MODEL=https://tfhub.dev/google/imagenet/mobilenet_v1_050_224/classification/1
TF_HUB_MODEL=https://tfhub.dev/google/imagenet/mobilenet_v1_050_224/feature_vector/1
# TF_HUB_MODEL=https://tfhub.dev/google/imagenet/mobilenet_v1_100_224/feature_vector/1
# TF_HUB_MODEL=https://tfhub.dev/google/imagenet/mobilenet_v2_050_224/feature_vector/2
# TF_HUB_MODEL=https://tfhub.dev/google/openimages_v4/ssd/mobilenet_v2/1

echo "Building docker image..."
docker build -t sandwiching tf_files/

# echo "Retraining model with given images..."
# docker run -it \
#   -v $(pwd)/tf_files:/tf_files \
#   -v $(pwd)/training_images/output:/input sandwiching python3 /tf_files/retrain.py \
#   --bottleneck_dir=/tf_files/bottlenecks \
#   --how_many_training_steps="${TRAINING_STEPS}" \
#   --summaries_dir=/tf_files/training_summaries/"${ARCHITECTURE}" \
#   --output_graph="${GRAPH}" \
#   --output_labels="${OUTPUT_LABELS}" \
#   --architecture="${ARCHITECTURE}" \
#   --image_dir=/input

# echo "Now to convert this puppy!"
# docker run -it \
#   -v $(pwd)/tf_files:/tf_files \
#   -v $(pwd)/training_images/output:/input sandwiching tflite_convert \
#   --graph_def_file=${GRAPH} \
#   --output_file=${OUTPUT} \
#   --input_format=TENSORFLOW_GRAPHDEF \
#   --output_format=TFLITE \
#   --output_array=final_result \
#   --inference_type=FLOAT \
#   --input_data_type=FLOAT
# --input_shape=1,${IMAGE_SIZE},${IMAGE_SIZE},3 \
# --input_array=input \

echo "Deleting old models"
rm -Rf $(pwd)/tf_files/models

# run with tfhub modules and modern script
echo "TRAIN!!! You're the best around!"
docker run -it \
  -v $(pwd)/tf_files:/tf_files \
  -v $(pwd)/training_images/output:/input sandwiching python3 ./retrain.py \
  --how_many_training_steps="${TRAINING_STEPS}" \
  --summaries_dir=/tf_files/training_summaries/"${ARCHITECTURE}" \
  --output_graph="${GRAPH}" \
  --output_labels="${OUTPUT_LABELS}" \
  --image_dir=/input \
  --tfhub_module="${TF_HUB_MODEL}" \
  --saved_model_dir=/tf_files/models \
  --learning_rate="${LEARNING_RATE}"
# --flip_left_right \

echo "Making it useable...."
docker run -it \
  -v $(pwd)/tf_files:/tf_files \
  -v $(pwd)/training_images/output:/input sandwiching tflite_convert \
  --graph_def_file=tf_files/retrained_graph.pb \
  --output_file=tf_files/sandwich.tflite \
  --output_array=final_result \
  --input_array=Placeholder


