# usage ./test_model.sh $IMAGE_PATH_HERE

python3 tf_files/label_image.py \
  --input_mean 0 --input_std 255 \
  --model_file tf_files/sandwich.tflite --label_file tf_files/retrained_labels.txt \
  --image="$1"