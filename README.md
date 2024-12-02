# WTTrack:  Exploring Frequency Domain Feature Fusion for Robust RGBT Tracking

Implementation of the paper (WTTrack: Wavelet Transform-Enhanced Feature Fusion for Robust RGBT Tracking)
## Environment Installation
```
conda create -n wttrack python=3.8
conda activate wttrack
bash install.sh
```

## Project Paths Setup
Run the following command to set paths for this project
```
python tracking/create_default_local_file.py --workspace_dir . --data_dir ./data --save_dir ./output
```
After running this command, you can also modify paths by editing these two files
```
lib/train/admin/local.py  # paths about training
lib/test/evaluation/local.py  # paths about testing
```

## Data Preparation
Put the tracking datasets in `./data`. It should look like:
```
${PROJECT_ROOT}
  -- data
      -- lasher
          |-- trainingset
          |-- testingset
          |-- trainingsetList.txt
          |-- testingsetList.txt
          ...
```

## Training
Download [SOT_Pretrained]() pretrained weights and put them under `$PROJECT_ROOT$/pretrained_models`.

```
python tracking/train.py --script wt_track --config vitb_256_wt_32x4_4e4_lasher_15ep_sot --save_dir ./output/vitb_256_wt_32x4_4e4_lasher_15ep_sot --mode multiple --nproc_per_node 4
```


Replace `--config` with the desired model config under `experiments/wt_track`.

## Evaluation
Put the checkpoint into `$PROJECT_ROOT$/output/config_name/...` or modify the checkpoint path in testing code.

```
python tracking/test.py wt_track vitb_256_wt_32x4_4e4_lasher_15ep_sot --dataset_name lasher_test --threads 6 --num_gpus 1
```

## Acknowledgments
Our project is developed upon [OSTrack](https://github.com/botaoye/OSTrack). Thanks for their contributions which help us to quickly implement our ideas.



