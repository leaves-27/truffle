pragma solidity ^0.4.23;

/*
* 主要解决的问题:
* 1.使投票统计自动；
* 2.使投票统计完全透明，防止操纵。 
*/


//提案
//  提案名称
//  累计投票数
//投票人
//  选票
//  选票权重
//委托人

//主持人

// @title 有委托人代替投票的投票
contract Ballot{

  //定义投票人
  struct Voter {
    uint weight;//该投票人持有的选票权重
    bool voted;//该投票人是否已经投票
    address delegate;//该投票人委托的投票人
    uint vote; //该投票人投的提案编号;
  }

  //定义提案
  struct Proposal {
    bytes32 name; //该提案的名称
    uint voteCount; //该提案累计获得的票数
  }

  address public chairperson; //用来存放主持人的地址

  mapping (address=> Voter) public voters; //声明一个变量votes，用来存放投票人及其对应的地址

  Proposal[] public proposals; //提案数组

  //初始化投票人及其提案
  function Ballot (bytes32[] proposalNames){
    chairperson = msg.sender;

    voters[chairperson].weight = 1;

    for(uint i=0;i<proposalNames.length;i++)
      proposals.push(
        Proposal({
          name :proposalNames[i],
          voteCount 0
        })
      )
  }

  //分配投票权(只能由主持人调用)
  function giveRightToVote (address voter){
    if(msg.sender!= chairperson || voters[voter].voted){
      throw;
    }

    voters[voter].weight = 1;
  }
  

  //委托函数，用于将投票权委托给某人
  function delegate (address to) {
    Voter sender = voters[msg.sender];
    if(sender.voted)
      throw;

    while(voters[to].delegate != address(0) && voters[to].delegate != msg.sender)
      to = voters[to].delegate;

    if(to == msg.sender)
      throw;

    sender.voted = true;
    sender.delegate = to;

    Voter delegate = voters[to];

    if(delegate.voted)
      proposals[delegate.vote].voteCount += sender.weight;
    else
      delegate.weight += sender.weight;
  }

  //投票人进行投票
  function vote (uint proposal){
    Voter sender = voters[msg.sender];
    if(sender.voted) throw;
    sender.voted = true;
    sender.vote = proposal;

    proposals[proposal].voteCount += sender.weight;
  }

  //计算获胜提案
  function winningProposal () constant returns(uint winningProposal){
    uint winninVoteCount = 0;
    for(uint p=0;p<proposals.length;p++){
      if(proposals[p].voteCount > winninVoteCount){
        winninVoteCount = proposals[p].voteCount;
        winningProposal = p;
      }
    }
  }
  



  
  

  
  
  
  

 
}
