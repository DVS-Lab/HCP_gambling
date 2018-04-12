
PPI Effect Size with HCP data

## Main steps of analysis:
- Smoothing
- Obtain motion files to run ICA AROMA for each subject
- ICA AROMA to correct for motion
- Level 1 Basic Activation Model
- Level 1 PPI Model
- Level 2
- Effect Size Calculation

### Key Scripts
- EffectSize.py: calculates effect size, from Russell Poldrack's group
- L1_Emo_Act: Runs basic activation model for the HCP Emotion task via Feat
- L1_Soc_Act: Runs basic activation model for the HCP Social task via Feat
- L1_WM_Act: Runs basic activation model for the HCP Working Memory task via Feat
- runAROMA.sh: Called on by submit_runAROMA.sh, runAROMA.sh is the main script that performs ICA_AROMA on the smoothed data
- submit_runAROMA.sh: Calls on runAROMA.sh and limits the number of concurrent subjects being processed to 30 (restrictions due to being processed on compute.temple.edu)
