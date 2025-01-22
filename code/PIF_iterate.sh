data_name='amazon_book' 
cuda=6
damp=0.02
num_per_gpu=1 
trial_name=trial 

seed=0
generate_num=80 
min_item_num=50
perturb_ratio=0.01
ensemble_k=5


for iter_num in   $(seq 0 10) 
    do
    valid_num=1
    test_num=2
    rec_model=NCF
    synthetic_data_path=synthetic_data/${data_name}/tallrec_base/generate_num${generate_num}_for_data2_v0_generate_seed_${seed}.pkl
    if_sampling=deter 
    influence_save_name=generate_num${generate_num}_generate_seed_${seed}_1002_min_item_${min_item_num}_perturb_ratio_${perturb_ratio}_ensemble_k_${ensemble_k}_new3

    if [ ${iter_num} -eq 0 ]; then

        ############# do not calculate IF

        if_load_model_exp_name=tallrec_base_valid_0_generate_num${generate_num}_for_data2_v0_generate_seed_${seed}_iter_0
        python PIF_iterate.py --rec_model ${rec_model} --data_name ${data_name} --cuda ${cuda}\
            --num_per_gpu ${num_per_gpu} --trial_name ${trial_name} \
            --test_num 2 --exp_name ${exp_name} --synthetic_data_path ${synthetic_data_path} --valid_num 0\
            --if_sampling $if_sampling --influence_save_name $influence_save_name \
            --if_load_model_exp_name $if_load_model_exp_name --iter_num $iter_num  --perturb_ratio $perturb_ratio\
            --min_item_num $min_item_num 
    else

        if_load_model_exp_name=${influence_save_name}_$((${iter_num} - 1))
        
    fi

    exp_name=${influence_save_name}_${iter_num}

    ############# cal IF
    python calculate_IF.py --rec_model ${rec_model} --data_name ${data_name} --cuda ${cuda}\
        --valid_num $valid_num --test_num $test_num --synthetic_data_path $synthetic_data_path\
        --if_load_model_exp_name $if_load_model_exp_name \
        --init_mul 1 --damp $damp --cal_influence_on valid\
        --influence_save_name $influence_save_name  --iter_num $iter_num

    ################# PIF iterate
    python PIF_iterate.py --rec_model ${rec_model} --data_name ${data_name} --cuda ${cuda}\
        --num_per_gpu ${num_per_gpu} --trial_name ${trial_name} \
        --test_num 2 --exp_name ${exp_name} --synthetic_data_path ${synthetic_data_path} --valid_num 0\
        --if_sampling $if_sampling --influence_save_name $influence_save_name \
        --if_load_model_exp_name $if_load_model_exp_name --iter_num $iter_num  --perturb_ratio $perturb_ratio\
        --min_item_num $min_item_num 

    done


python PIF_inference.py --rec_model ${rec_model} --data_name ${data_name} --cuda ${cuda}\
    --num_per_gpu ${num_per_gpu} --trial_name ${trial_name} \
    --test_num 2 --exp_name ${exp_name} --synthetic_data_path ${synthetic_data_path} --valid_num 0\
    --if_sampling $if_sampling --influence_save_name $influence_save_name \
    --if_load_model_exp_name $if_load_model_exp_name --iter_num $iter_num  --perturb_ratio $perturb_ratio\
    --min_item_num $min_item_num --ensemble_k ${ensemble_k}


