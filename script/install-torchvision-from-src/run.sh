#!/bin/bash

# Set LD_LIBRARY_PATH to ensure all dependencies are correctly loaded
export LD_LIBRARY_PATH=/opt/hpcx/ucx/lib:/opt/hpcx/ucc/lib:/opt/hpcx/ompi/lib:/usr/local/lib/python3.10/dist-packages/torch/lib:$LD_LIBRARY_PATH
export PYTHONPATH="/usr/local/lib/python3.10/dist-packages"
# Check if torchvision is already installed
if python3 -c "import torchvision; print(torchvision.__version__)" &> /dev/null; then
  echo "Torchvision is already installed. Skipping source build."
  exit 0
fi

echo "Torchvision check failed, proceeding with source build."

CUR_DIR=$PWD
rm -rf pytorchvision
cp -r ${CM_PYTORCH_VISION_SRC_REPO_PATH} pytorchvision
cd pytorchvision
test "${?}" -eq "0" || exit $?
rm -rf build

${CM_PYTHON_BIN_WITH_PATH} setup.py bdist_wheel
test "${?}" -eq "0" || exit $?
cd dist
${CM_PYTHON_BIN_WITH_PATH} -m pip install torchvision*linux_x86_64.whl
test "${?}" -eq "0" || exit $?

