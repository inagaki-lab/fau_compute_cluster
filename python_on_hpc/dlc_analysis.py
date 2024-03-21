import deeplabcut
from pathlib import Path

def run(config_path, video_dir):
    '''Analyzes videos with DLC

    Parameters
    ----------
    config_path : path-like
        Path to the config.yaml file
    video_dir : pathlib.Path
        Path to the directory containing the videos to analyze
    '''

    # find all mp4 files in video_dir
    videos = video_dir.glob('*.mp4')
    
    # convert Path to string (DLC can't handle pathlib)
    videos = [ str(v) for v in videos ] 

    # analyze videos
    deeplabcut.analyze_videos(config_path, videos, save_as_csv=True)
    deeplabcut.filterpredictions(config_path, videos, save_as_csv=True)
    deeplabcut.create_labeled_video(config_path, videos, videotype='.mp4', filtered=True)

if __name__ == '__main__':

    # absolute path to the current working directory
    working_dir = Path().absolute()

    # project directory relative to the working directory
    project_dir = working_dir # / 'camF_FS34_RN101-BidayeLab-2022-10-01'

    # config.yaml file and videos
    config_path = project_dir / 'config.yaml'
    video_dir = project_dir / '0_for_2ndIT' / 'select15'

    run(config_path, video_dir)
