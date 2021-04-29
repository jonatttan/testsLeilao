//
//  LilaoDaoFalso.swift
//  Leilao
//
//  Created by Jonattan Moises Sousa on 29/04/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import Foundation

class LeilaoDaoFalso {
    
    private var listaLeiloes:[Leilao] = []
    
    func salva(_ leilao: Leilao) {
        listaLeiloes.append(leilao)
    }
    func encerrados() -> [Leilao] {
        
        return listaLeiloes.filter({ $0.encerrado == true })
    }
    func correntes() -> [Leilao] {
        
        return listaLeiloes.filter({ $0.encerrado == false })
    }
    func atualiza(leilao: Leilao) {}
}
