/*
* ============================================
* @apexEnaumName: CheckRecurtion
* @description: stops trigger from recursing
* @author: paata gvichia
* @email: paatagvichia@gmail.com
* @dateCreated: 06/06/2022
* ============================================
*/
public with sharing class SF_CheckRecurtion {
    @TestVisible
    private static boolean run = true;
    public static boolean runOnce(){
      if(run){
       run=false;
       return true;
      }else{
        return run;
      }
    }
}