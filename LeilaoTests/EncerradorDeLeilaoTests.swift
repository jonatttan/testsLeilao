//
//  EncerradorDeLeilaoTests.swift
//  LeilaoTests
//
//  Created by Jonattan Moises Sousa on 29/04/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import XCTest
@testable import Leilao
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
        let dao = LeilaoDao()
        dao.salva(tvLed)
        dao.salva(geladeira)
        
        // Rodamos o encerrador de leilões
        let encerradorDeLeilao = EncerradorDeLeilao()
        encerradorDeLeilao.encerra()
        
        let leiloesEncerrados = dao.encerrados()
        
        // Verificamos se esses leilões de data antiga foram encerrados
        guard let statusTvLed = tvLed.isEncerrado() else { return }
        guard let statusGeradeira = geladeira.isEncerrado() else { return }
        
        XCTAssertTrue(statusTvLed)
        XCTAssertTrue(statusGeradeira)
    }
}
