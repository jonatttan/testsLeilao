//
//  EncerradorDeLeilaoTests.swift
//  LeilaoTests
//
//  Created by Jonattan Moises Sousa on 29/04/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import XCTest
@testable import Leilao
import Cuckoo

class EncerradorDeLeilaoTests: XCTestCase {

    override func setUp(){
        super.setUp()
    }

    override func tearDownWithError() throws {
    }
    func testDeveEncerrarLeiloesIniciadosUmaSemanaAntes() {
        let formatador = DateFormatter()
        formatador.dateFormat = "yyyy/MM/dd"
        guard let dataAntiga = formatador.date(from: "2021/04/19") else { return }
        
        // Criamos dois leilões com data antiga
        let tvLed = CriadorDeLeilao().para(descricao: "TV Led").naData(data: dataAntiga).constroi()
        let geladeira = CriadorDeLeilao().para(descricao: "Geladeira").naData(data: dataAntiga).constroi()
        
        // Gravamos os leilões no banco de dados
        let daoFalso = MockLeilaoDao()
        
        // Para termos um retorno dos leiloes correntes, tratamos essa função aqui dentro, forjando um retorno sem precisar sair daqui. Ensinamos pelo stub ao Mock que "Quando essa função for chamada, devolva isso".
        let leiloesAntigos = [tvLed, geladeira]
        stub(daoFalso) { (daoFake) in
            when(daoFake.correntes()).thenReturn(leiloesAntigos)
        }
        
        // Após implementar o stub, orientamos o mock a chamar da classe concreta/ verdadeira os métodos que não estão no stub
        daoFalso.withEnabledSuperclassSpy() // Pode ser também implementado na instência, com "let daoFalso.width..."
        
        // Rodamos o encerrador de leilões, nesse ponto ocorre a injeção de dependência.
        let encerradorDeLeilao = EncerradorDeLeilao(daoFalso)
        encerradorDeLeilao.encerra()
        
        guard let statusTvLed = tvLed.isEncerrado() else { return }
        guard let statusGeladeira = geladeira.isEncerrado() else { return }
        
        // Pegamos od leilões encerrados e verificamos quantos são
        XCTAssertEqual(2, encerradorDeLeilao.getTotalEncerrados() , "Aquantidade de leilões encerrados não é a esperada.")
        // Verificamos se esses leilões de data antiga foram encerrados
        XCTAssertTrue(statusTvLed)
        XCTAssertTrue(statusGeladeira)
    }
}
