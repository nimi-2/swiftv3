//
//  MemoGameModel.swift
//  MemoryGame
//
//  Created by student on 05/12/2024.
//

import Foundation


struct MemoGameModel<CardContent : Equatable> {

    private(set) var cards: Array<Card>
    private(set) var mainCard: Card? = nil
    private(set) var score: Int = 0
    
    
    init(numberOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        let randoms = Int.random(in: 0..<numberOfCards)
        for i in 0..<numberOfCards {
            let content = cardContentFactory(i)
            cards.append(Card(id: "\(UUID())_a", content: content))
            cards.append(Card(id: "\(UUID())_b", content: content))
            if(i == randoms){
        
                mainCard = Card(isFaceUp: true, id: "1", content: content)
            }
        }
        cards.shuffle()
        
        
    }
    
    mutating func addScore() {
        score += 10
    }
    
    mutating func minusScore() {
        score -= 1
    }
    
    func index(card: Card) -> Int?{
        for index in cards.indices{
            if(cards[index].id == card.id) {
                return index
            }
        }
        return nil
    }
    
    func indexFace(card: Card)->Int?{
        for index in cards.indices{
            if(cards[index].isFaceUp){
                if(cards[index].id != card.id){
                    return index
                }
            }
                
        }
        return nil
    }
    
   
    
    
    // wszystkie zakryte
    // choose
    // sprawdz czy aktualnie kliknieta = lastchosen
    // jezeli tak to zmatchuj obie i ustaw na nie widzialne
    // jezeli nie  to zakryj obie
    
    
    mutating func getNewMainCard() {
        let randoms = Int.random(in: 0..<cards.count)
        // index, czy karta w cards jest juz matched z tym symbolem jezeli nie to to bedzie nowa maincard
        for index in cards.indices {
            if cards[index].content != cards[randoms].content {
                if !cards[index].isMatched {
                    mainCard = Card(isFaceUp: true, id: "1", content: cards[index].content)
                    
                    return
                }
            }
        }
//        mainCard = Card(isFaceUp: true, id: "1", content: content)
        
    }
    
    var lastChosen: Card? = nil
    
    func get_prev_index() -> Int? {
        if let prev_chosen = lastChosen, let index_of_prev = index(card: prev_chosen) {
            return index_of_prev
        }
        
        return nil
    }
    
    var re_different: Bool = false
    

    var indexDoWywalenia3: Int = 0
    var indexDoWywalenia2: Int = 0
    mutating func choose(card: Card) {
        
        
        
        if re_different {
            cards[indexDoWywalenia3].isFaceUp = false
            cards[indexDoWywalenia2].isFaceUp  = false
            re_different = false
                
        }
       
        if let index = index(card: card) {
            cards[index].isFaceUp = true
            
            print("odkryto karte")
            if let get_prev_index = get_prev_index() {
                print("porpzednia istnieje")
                if cards[index].content == cards[get_prev_index].content &&
                    cards[index].id != cards[get_prev_index].id {
                    print("match")
                    cards[index].visible = false
                    cards[get_prev_index].visible = false
                } else {
                    print("rozne")
                    indexDoWywalenia3 = index
                    indexDoWywalenia2 = get_prev_index
                    re_different = true

                }
                lastChosen = nil
            } else {
                
                print("poprzednia nie istnieje")
                lastChosen = card
                
            }

            
        }
  
    }
    
    
    mutating func shuffle(){
        cards.shuffle()
    }
    
    struct Card : Equatable, Identifiable  {
        var isFaceUp = false
        var isMatched = false
        var visible = true
        var id: String
        let content: CardContent
    }
}
