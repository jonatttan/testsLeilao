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
        let dao = LeilaoDaoFalso()
        dao.salva(tvLed)
        dao.salva(geladeira)
        
        // Rodamos o encerrador de leilões
        let encerradorDeLeilao = EncerradorDeLeilao(dao)
        encerradorDeLeilao.encerra()
        
        // Pegamos od leilões encerrados e verificamos quantos são
        let leiloesEncerrados = dao.encerrados()
        XCTAssertEqual(2, leiloesEncerrados.count, "Aquantidade de leilões encerrados não é a esperada.")
        
        // Verificamos se esses leilões de data antiga foram encerrados
        XCTAssertTrue(leiloesEncerrados[0].isEncerrado()!)
        XCTAssertTrue(leiloesEncerrados[1].isEncerrado()!)
    }
}
