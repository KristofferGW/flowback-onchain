// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import './PollStructs.sol';
import './ProposalStructs.sol';
import './PredictionStructs.sol';

contract PredictionBets is PollStructs, ProposalStructs, PredictionStructs {

     struct PredictionBet{
        uint pollId;
        uint proposalId;
        uint predictionId;
        bool bet;
        uint likelihood;
        PollPhase phase;
    }

    mapping(uint => PredictionBet[]) public predictionBets;
    event PredictionBetCreated(uint indexed predictionId, bool bet, uint likelihood);

    function _requireExist(uint _pollId, uint _proposalId, uint _predictionId) private view {
        require(requirePollPropPredToExist(_pollId, _proposalId, _predictionId), "Wrong poll, proposal or prediction");
    }

    modifier requireExist(uint _pollId, uint _proposalId,uint _predictionId){
        _requireExist(_pollId, _proposalId, _predictionId);
        _;
    }
    function placePredictionBet(
        uint _pollId,
        uint _proposalId,
        uint _predictionId, 
        uint _likelihood,
        bool _bet
    )  external requireExist(_pollId, _proposalId, _predictionId){
      
        require(_likelihood > 0 , "Value needs to be higher than 0");
        bool rightPhase = predictions[_proposalId][_predictionId-1].phase == PollPhase.predictionBetPhase;
        require(rightPhase, "You can not place a bet at this time");
          
        predictionBets[_predictionId].push(PredictionBet({
            pollId: _pollId,
            proposalId: _proposalId,
            predictionId: _predictionId,
            likelihood: _likelihood,
            bet: _bet,
            phase: PollPhase.completedPhase
        }));
            
        emit PredictionBetCreated(_predictionId, _bet, _likelihood);
    }

    function requirePollPropPredToExist(uint _pollId, uint _proposalId, uint _predictionId) internal view returns (bool){
        
        //require poll to exist,
        //require proposal to exist
        //check if prediction exist

        //checks if prediction exist-----
        // uint proposalsLength = proposals[_pollId].length;
        // for (uint a=0; a <= proposalsLength;){
        //     if (proposals[_pollId][a].proposalId ==_proposalId){
        //         uint predictionsLength = predictions[_proposalId].length;
        //         for (uint b=0; b <= predictionsLength;){
        //             if (predictions[_proposalId][b].predictionId ==_predictionId)
        //                 return true;
        //                 unchecked {
        //                     ++b;
        //                 }
        //         }
        //         return false;
        //     }
        //     unchecked {
        //     ++a;
        //     }
        // }
        // return false;
    }

    function getPredictionBets( 
        uint _pollId, 
        uint _proposalId, 
        uint _predictionId
        ) external requireExist(_pollId, _proposalId, _predictionId) view returns(PredictionBet[] memory) {

        uint proposalsLength = proposals[_pollId].length;
        for (uint a=0; a <= proposalsLength;){
            if(proposals[_pollId][a].proposalId == _proposalId){
                uint predictionsLength =predictions[_proposalId].length;
                for (uint b=0; b <= predictionsLength;){
                    if(predictions[_proposalId][b].predictionId == _predictionId)
                        return predictionBets[_predictionId];
                    unchecked {
                        ++b;
                    }
                }
            }
            unchecked {
                ++a;
            }
        }
        return predictionBets[_predictionId];
    }

}