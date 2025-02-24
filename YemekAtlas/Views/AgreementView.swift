//
//  AgreementView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 20.10.2024.
//

import SwiftUI

struct AgreementView: View {
    var body: some View {
        ScrollView{
            VStack(alignment: .leading) {
               Text("""
MADDE 1– TARAFLAR


İşbu sözleşme ve ekleri (EK-1 Gizlilik Sözleşmesi) “Aydınevler Mah. İnönü Cad. Rönesans Biz Plaza A Blok No:20 Kat:5 Maltepe/İstanbul” adresinde mukim “Sodexo Avantaj ve Ödüllendirme Hizmetleri Anonim Şirketi” (bundan böyle "Sodexo" olarak anılacaktır) ile Sodexo mobil uygulamalarından iş bu sözleşmede belirtilen koşullar dahilinde yararlanan Kullanıcı ile karşılıklı olarak kabul edilerek yürürlüğe girmiştir.
""")
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        }
        .padding()
    }
    }
}

#Preview {
    AgreementView()
}
