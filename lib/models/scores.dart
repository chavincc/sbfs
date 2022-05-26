typedef ScoreInstance = Map<String, int>;
typedef ScoreTemplate = Map<String, TemplateMap>;
typedef TemplateMap = Map<int, String>;

const Map<String, List<String>> titleGroup = {
  'Resting': ['Eye', 'Nasolabial', 'Mouth'],
  'Voluntary Movement': [
    'Brow Lift',
    'Gentle Eye Closure',
    'Open Mouth Smile',
    'Snarl',
    'Lip Pucker',
  ],
  'Synkinesis': [
    'Brow Lift Synkinesis',
    'Gentle Eye Closure Synkinesis',
    'Open Mouth Smile Synkinesis',
    'Snarl Synkinesis',
    'Lip Pucker Synkinesis',
  ],
};

const ScoreTemplate scoreTemplate = {
  'Eye': {
    0: 'normal',
    1: 'narrow/wide/eye surgery',
  },
  'Nasolabial': {
    0: 'normal',
    1: 'more/less',
    2: 'absent',
  },
  'Mouth': {
    0: 'normal',
    1: 'corner dropped/pulled up',
  },
  'Brow Lift': {
    1: '',
    2: '',
    3: '',
    4: '',
    5: '',
  },
  'Gentle Eye Closure': {
    1: '',
    2: '',
    3: '',
    4: '',
    5: '',
  },
  'Open Mouth Smile': {
    1: '',
    2: '',
    3: '',
    4: '',
    5: '',
  },
  'Snarl': {
    1: '',
    2: '',
    3: '',
    4: '',
    5: '',
  },
  'Lip Pucker': {
    1: '',
    2: '',
    3: '',
    4: '',
    5: '',
  },
  'Brow Lift Synkinesis': {
    1: '',
    2: '',
    3: '',
    4: '',
    5: '',
  },
  'Gentle Eye Closure Synkinesis': {
    1: '',
    2: '',
    3: '',
    4: '',
    5: '',
  },
  'Open Mouth Smile Synkinesis': {
    1: '',
    2: '',
    3: '',
    4: '',
    5: '',
  },
  'Snarl Synkinesis': {
    1: '',
    2: '',
    3: '',
    4: '',
    5: '',
  },
  'Lip Pucker Synkinesis': {
    1: '',
    2: '',
    3: '',
    4: '',
    5: '',
  },
};
