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
    0: '',
    1: '',
    2: '',
    3: '',
  },
  'Gentle Eye Closure Synkinesis': {
    0: '',
    1: '',
    2: '',
    3: '',
  },
  'Open Mouth Smile Synkinesis': {
    0: '',
    1: '',
    2: '',
    3: '',
  },
  'Snarl Synkinesis': {
    0: '',
    1: '',
    2: '',
    3: '',
  },
  'Lip Pucker Synkinesis': {
    0: '',
    1: '',
    2: '',
    3: '',
  },
};

ScoreInstance json2scoreInstance(List<dynamic> json) {
  return {
    'Eye': json[0][0][0],
    'Nasolabial': json[0][0][1],
    'Mouth': json[0][0][2],
    'Brow Lift': json[0][1][0],
    'Gentle Eye Closure': json[0][1][1],
    'Open Mouth Smile': json[0][1][2],
    'Snarl': json[0][1][3],
    'Lip Pucker': json[0][1][4],
    'Brow Lift Synkinesis': json[0][2][0],
    'Gentle Eye Closure Synkinesis': json[0][2][1],
    'Open Mouth Smile Synkinesis': json[0][2][2],
    'Snarl Synkinesis': json[0][2][3],
    'Lip Pucker Synkinesis': json[0][2][4],
  };
}

int getTotalScore(ScoreInstance si) {
  try {
    final totalResting = 5 * (si['Eye']! + si['Nasolabial']! + si['Mouth']!);
    final totalMovement = 4 *
        (si['Brow Lift']! +
            si['Gentle Eye Closure']! +
            si['Open Mouth Smile']! +
            si['Snarl']! +
            si['Lip Pucker']!);
    final totalSynkinesis = (si['Brow Lift Synkinesis']! +
        si['Gentle Eye Closure Synkinesis']! +
        si['Open Mouth Smile Synkinesis']! +
        si['Snarl Synkinesis']! +
        si['Lip Pucker Synkinesis']!);
    return totalMovement - totalResting - totalSynkinesis;
  } catch (error) {
    return 0;
  }
}

List<dynamic> scoreInstance2json(ScoreInstance si) {
  return [
    [
      [
        si['Eye'],
        si['Nasolabial'],
        si['Mouth'],
        0,
        0,
      ],
      [
        si['Brow Lift'],
        si['Gentle Eye Closure'],
        si['Open Mouth Smile'],
        si['Snarl'],
        si['Lip Pucker']
      ],
      [
        si['Brow Lift Synkinesis'],
        si['Gentle Eye Closure Synkinesis'],
        si['Open Mouth Smile Synkinesis'],
        si['Snarl Synkinesis'],
        si['Lip Pucker Synkinesis'],
      ]
    ],
    getTotalScore(si),
  ];
}
