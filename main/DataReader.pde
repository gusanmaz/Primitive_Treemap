class DataReader{
  int leafLineCnt;
  int nonLeafLineCnt;
  LeafData[] leafData;
  NonLeafData[] nonLeafData;
  
  int rootID;
  
  public DataReader(String fileName){
    String line;
    BufferedReader reader = createReader(fileName);
    String[] pieces;

    try{
      line = reader.readLine();
    }
    catch (IOException e) {
      e.printStackTrace();
      line = null;
    }
    
    leafLineCnt = int(line);
    leafData = new LeafData[leafLineCnt];
        
    for(int i = 0; i < leafLineCnt; i++){
      try{
        line               = reader.readLine();
        pieces             = split(line, ',');
        leafData[i]        = new LeafData();
        leafData[i].id     = int(pieces[0]);
        leafData[i].value  = float(pieces[1]);
      }
      catch (IOException e) {
        e.printStackTrace();
        line = null;
      }
    }
    
    try{
      line = reader.readLine();
    }
    catch (IOException e) {
      e.printStackTrace();
      line = null;
    }
    
    nonLeafLineCnt = int(line);
    nonLeafData = new NonLeafData[nonLeafLineCnt];
    
    for(int i = 0; i < nonLeafLineCnt; i++){
      try{
        line                   = reader.readLine();
        pieces                 = split(line, ',');
        nonLeafData[i]         = new NonLeafData();
        nonLeafData[i].parentID  = int(pieces[0]);
        nonLeafData[i].childID   = int(pieces[1]);
        
      }
      catch (IOException e) {
        e.printStackTrace();
        line = null;
      }
    }
    
    int someNodeID = nonLeafData[0].parentID; //Questionable????
    boolean parentFound;
    
    while(true){
      parentFound = false;
      for(int i = 0; i < nonLeafLineCnt; i++){
        if (nonLeafData[i].childID == someNodeID){
          parentFound = true;
          someNodeID = nonLeafData[i].parentID;
          break;
        }
      }
      if (!parentFound){
        break;
      }
    }
    rootID = someNodeID;
  }
  
  LeafData[] getLeafData(){
    return leafData;
  }
  
  NonLeafData[] getNonLeafData(){
    return nonLeafData;
  }
  
  int getRootID(){
    println(rootID);
    return rootID;
  }
  
}
