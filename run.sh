#!/bin/bash

# 打印模式选择
echo "请选择模式："
echo "1: train"
echo "2: test"
echo "3: analysis"

# 用户输入模式
read -p "请输入模式序号：" mode_index

# 检查输入的模式序号是否有效
if [[ ! "$mode_index" =~ ^[1-3]$ ]]; then
  echo "输入的模式序号无效，请输入 1、2 或 3。"
  exit 1
fi

# 获取模式
case $mode_index in
  1)
    mode="train"
    ;;
  2)
    mode="test"
    ;;
  3)
    mode="analysis"
    ;;
esac

# 获取当前目录下的所有文件
files=$(ls ./experiments/tbsi_track)

# 去掉扩展名，得到配置名
configs=()
for file in $files; do
  config=$(echo $file | sed 's/.yaml//')
  configs+=($config)
done

# 打印配置名
echo "配置名列表："
for i in "${!configs[@]}"; do
  echo "$i: ${configs[$i]}"
done

# 用户输入序号，获取对应的配置名
read -p "请输入序号：" index

# 检查输入的序号是否有效
if [[ ! "$index" =~ ^[0-9]+$ ]]; then
  echo "输入的序号无效，请输入数字。"
  exit 1
fi

# 获取对应的配置名
if [[ "$index" -lt ${#configs[@]} ]]; then
  config_name=${configs[$index]}
else
  echo "输入的序号超出范围，请输入有效的序号。"
  exit 1
fi

# 输入 GPU id
read -p "请指定运行的显卡：" gpu_id

# 检查输入的模式序号是否有效
if [[ ! "$gpu_id" =~ ^[0-7]$ ]]; then
  echo "输入的模式序号无效，请输入 0 ~ 7。"
  exit 1
fi


# 执行不同的命令
command=""
case $mode in
  train)
    command="python ./tracking/train.py --script tbsi_track --config $config_name --save_dir ./output --mode single --nproc_per_node 4 --gpu_id $gpu_id"
    ;;
  test)
    command="python ./tracking/test.py tbsi_track $config_name --dataset_name lasher_test --threads 2 --num_gpus 1 --runid 15 --gpu_id $gpu_id"
    ;;
  analysis)
    command="python ./tracking/analysis_results.py --tracker_name tbsi_track --tracker_param $config_name --dataset_name lasher_test --runid 15"
    ;;
esac

echo $command
$command