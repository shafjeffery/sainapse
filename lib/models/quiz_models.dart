class Quiz {
  final String id;
  final String title;
  final String description;
  final List<Question> questions;
  final DateTime createdAt;
  final String status; // 'generating', 'completed', 'failed'
  final String userId;
  final String documentId;
  final int totalQuestions;
  final int timeLimit; // in minutes

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
    required this.createdAt,
    required this.status,
    required this.userId,
    required this.documentId,
    required this.totalQuestions,
    this.timeLimit = 30,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      questions: (json['questions'] as List<dynamic>?)
          ?.map((q) => Question.fromJson(q))
          .toList() ?? [],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      status: json['status'] ?? 'generating',
      userId: json['userId'] ?? '',
      documentId: json['documentId'] ?? '',
      totalQuestions: json['totalQuestions'] ?? 0,
      timeLimit: json['timeLimit'] ?? 30,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'questions': questions.map((q) => q.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'status': status,
      'userId': userId,
      'documentId': documentId,
      'totalQuestions': totalQuestions,
      'timeLimit': timeLimit,
    };
  }
}

class Question {
  final String id;
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final String difficulty; // 'easy', 'medium', 'hard'
  final String category;

  Question({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    required this.difficulty,
    required this.category,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? '',
      questionText: json['questionText'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswerIndex: json['correctAnswerIndex'] ?? 0,
      explanation: json['explanation'] ?? '',
      difficulty: json['difficulty'] ?? 'medium',
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionText': questionText,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
      'difficulty': difficulty,
      'category': category,
    };
  }
}

class QuizResult {
  final String quizId;
  final String userId;
  final List<int> userAnswers;
  final int score;
  final int totalQuestions;
  final double percentage;
  final DateTime completedAt;
  final Duration timeTaken;

  QuizResult({
    required this.quizId,
    required this.userId,
    required this.userAnswers,
    required this.score,
    required this.totalQuestions,
    required this.percentage,
    required this.completedAt,
    required this.timeTaken,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      quizId: json['quizId'] ?? '',
      userId: json['userId'] ?? '',
      userAnswers: List<int>.from(json['userAnswers'] ?? []),
      score: json['score'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      percentage: (json['percentage'] ?? 0.0).toDouble(),
      completedAt: DateTime.parse(json['completedAt'] ?? DateTime.now().toIso8601String()),
      timeTaken: Duration(seconds: json['timeTakenSeconds'] ?? 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quizId': quizId,
      'userId': userId,
      'userAnswers': userAnswers,
      'score': score,
      'totalQuestions': totalQuestions,
      'percentage': percentage,
      'completedAt': completedAt.toIso8601String(),
      'timeTakenSeconds': timeTaken.inSeconds,
    };
  }
}

class DocumentUpload {
  final String id;
  final String fileName;
  final String fileType;
  final String s3Key;
  final String status; // 'uploading', 'processing', 'completed', 'failed'
  final DateTime uploadedAt;
  final String userId;

  DocumentUpload({
    required this.id,
    required this.fileName,
    required this.fileType,
    required this.s3Key,
    required this.status,
    required this.uploadedAt,
    required this.userId,
  });

  factory DocumentUpload.fromJson(Map<String, dynamic> json) {
    return DocumentUpload(
      id: json['id'] ?? '',
      fileName: json['fileName'] ?? '',
      fileType: json['fileType'] ?? '',
      s3Key: json['s3Key'] ?? '',
      status: json['status'] ?? 'uploading',
      uploadedAt: DateTime.parse(json['uploadedAt'] ?? DateTime.now().toIso8601String()),
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'fileType': fileType,
      's3Key': s3Key,
      'status': status,
      'uploadedAt': uploadedAt.toIso8601String(),
      'userId': userId,
    };
  }
}
