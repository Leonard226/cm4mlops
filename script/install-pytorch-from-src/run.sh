#!/bin/bash

# Set LD_LIBRARY_PATH to ensure PyTorch can be imported correctly
export LD_LIBRARY_PATH=/opt/hpcx/ucx/lib:/opt/hpcx/ucc/lib:/opt/hpcx/ompi/lib:/usr/local/lib/python3.10/dist-packages/torch/lib:$LD_LIBRARY_PATH
export PYTHONPATH="/usr/local/lib/python3.10/dist-packages"
# Check if PyTorch is already installed
if python3 -c "import torch; print(torch.__version__)" &> /dev/null; then
  echo "PyTorch is already installed. Skipping source build."
  exit 0
fi

gcc()
{
  ${CM_GCC_BIN_WITH_PATH} "$@"
}
export -f gcc

CUR_DIR=$PWD
if [[ ! -e pytorch/dist/torch*.whl ]]; then
  rm -rf pytorch
  cp -r ${CM_PYTORCH_SRC_REPO_PATH} pytorch
  cd pytorch
  git submodule sync
  git submodule update --init --recursive
  rm -rf build

  ${CM_PYTHON_BIN_WITH_PATH} -m pip install -r requirements.txt
  test $? -eq 0 || exit $?
  ${CM_PYTHON_BIN_WITH_PATH} setup.py bdist_wheel
  test $? -eq 0 || exit $?
else
  cd pytorch
fi

cd dist
${CM_PYTHON_BIN_WITH_PATH} -m pip install torch-2.*linux_x86_64.whl
test $? -eq 0 || exit $?

