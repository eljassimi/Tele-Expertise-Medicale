#!/bin/bash
MAVEN_HOME="/c/Program Files/Apache/maven"       # For Git Bash on Windows
CATALINA_HOME="/c/Tomcat/apache-tomcat-10.1.24"  # Path to Tomcat
PROJECT_DIR="/c/Users/You/IdeaProjects/TELE-EXPERTISE-MEDICAL"
WAR_NAME="tele-expertise-medical.war"

# -----------------------------------------
echo ""
echo "🚀 Packaging WAR with Maven..."
cd "$PROJECT_DIR" || { echo "❌ Project directory not found!"; exit 1; }

"$MAVEN_HOME/bin/mvn" clean package

if [ $? -ne 0 ]; then
    echo "❌ Maven build failed! Deployment aborted."
    exit 1
fi

echo ""
echo "📦 Copying WAR file to Tomcat webapps..."
cp -f "$PROJECT_DIR/target/$WAR_NAME" "$CATALINA_HOME/webapps/"

if [ $? -ne 0 ]; then
    echo "❌ Failed to copy WAR file!"
    exit 1
fi

echo ""
echo "🛑 Stopping Tomcat..."
"$CATALINA_HOME/bin/shutdown.sh"

echo "⏳ Waiting 2 seconds..."
sleep 2

echo ""
echo "▶️ Starting Tomcat..."
"$CATALINA_HOME/bin/startup.sh"

echo ""
echo "✅ Deployment completed successfully!"