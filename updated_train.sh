#!/bin/bash
/home/lotegau/.local/bin/make_image_classifier \
  --image_dir training_images/output \
  --tfhub_module https://tfhub.dev/google/tf2-preview/mobilenet_v2/feature_vector/4 \
  --image_size 224 \
  --saved_model_dir tf_files/models \
  --labels_output_file tf_files/retrained_labels.txt \
  --tflite_output_file tf_files/sandwich.tflite \
  --summaries_dir tf_files/log