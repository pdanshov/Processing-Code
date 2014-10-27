class Timer{
  
          int savedTime;//var to hold the time
	  int totalTime;//var to compare time
	  
	  Timer(int time) //constructor function
	  {
	    totalTime = time;//capture variable
	  }  

	  public void start()
	  {
	     savedTime = millis(); //set saved time to current millis
	  }
	  
	  public int getTime()
	  {
		int passedTime = millis()- savedTime; //gets elapsed time
		return passedTime;
	  }
	  public boolean isFinished()
	  {
	    int passedTime = millis()- savedTime; //gets elapsed time
	    if (passedTime > totalTime)//check if time is up
	    {
	      return true; 
	    }
	    else
	    {
	      return false;  
	    }
	  }   
  
  
}
