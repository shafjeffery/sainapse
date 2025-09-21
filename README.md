# 🌐 Sainapse VLE  
**Next-Gen Student-Centered Learning Hub**  
*AI-powered | AR Visualization | Gamified | Collaborative*

---

## 📖 Overview  
Sainapse VLE is a **student-centered virtual learning environment** designed as the *next generation after Frog VLE* in Malaysia.  
It simplifies complex notes with AI, supports multiple learning styles (text, sketch, video, AR, chat), and builds a collaborative student community.  

---

## 🚀 Key Features  
- 🎓 **Student Hub** – One-stop platform for learning & collaboration.  
- 🕹 **Gamified Learning** – Points, badges, and leaderboards to motivate students.  
- 🤖 **AI Note Simplification** – Convert slides/notes into mindmaps, flashcards, and quizzes.  
- 🖼 **AR Visualization** – Recognize sketches and display interactive 3D models.  
- 💬 **Community Sharing** – Share simplified notes, join study groups, and chat with peers.  

---

## 🏗 System Architecture  
![AWS Architecture Diagram](docs/architecture.png)  
*(Deployed on AWS Malaysia Region — ap-southeast-5)*  

**Core AWS Services Used:**  
- **Amazon S3** – Store notes, AR 3D models, and shared resources.  
- **Amazon Rekognition** – Sketch → Object recognition.  
- **Amazon Bedrock / SageMaker** – AI note summarization & quiz generation.  
- **AWS Lambda + API Gateway** – Serverless backend.  
- **Amazon DynamoDB** – Store user data, progress, and community posts.  

---

## 📹 Demo  
👉 [Pitch Deck Slides](#https://www.canva.com/design/DAGzfDzbfns/-E_23aWsxkRdjrHx0lWJhQ/edit?utm_content=DAGzfDzbfns&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton) 

---

## ⚡ Installation & Setup  

### Prerequisites  
- Flutter SDK installed  
- AWS account (with credits for hackathon)  
- Node.js (for backend functions)  

### Clone Repository  
```bash
git clone https://github.com/your-username/sainapse-vle.git
cd sainapse-vle

