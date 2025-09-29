pipeline {
  agent any
  stages {
    stage('Cleanup') {
      steps {
        sh '''
          PID=$(lsof -ti tcp:9082 || true)
          if [ -n "$PID" ]; then kill -9 $PID; fi
          sudo -u ec2-user rm -rf /home/ec2-user/sample.daytrader7
        '''
      }
    }
    stage('Clone & Build') {
      steps {
        sh '''
          sudo -u ec2-user git clone https://github.com/narayan1989-bais/sample.daytrader7.git /home/ec2-user/sample.daytrader7
          sudo -u ec2-user bash -c "cd /home/ec2-user/sample.daytrader7 && mvn install"
        '''
      }
    }
    stage('Start App') {
      steps {
        sh '''
          sudo -u ec2-user bash -c "cd /home/ec2-user/sample.daytrader7/daytrader-ee7 && nohup mvn liberty:run > app.log 2>&1 &"
          sleep 5
          sudo -u ec2-user tail -n 20 /home/ec2-user/sample.daytrader7/daytrader-ee7/app.log
        '''
      }
    }
  }
}
