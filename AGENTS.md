# Projekt-Regeln für KI-Assistenten

## 1. Didaktische Tools allgemein
Alle interaktiven Tools in diesem Repository (Single-Page-Apps ohne Build-Schritt) folgen den Konventionen in [SKILL.md](file:///.claude/skills/didaktische-tools/SKILL.md):
- Lösungen dürfen nicht erratbar sein (10s Prüfsperre bei Fehlern, grobe Rückmeldungen).
- Desktop und Mobilgeräte (iOS/Android) müssen ohne horizontales Scrollen funktionieren.
- Stand/Fortschritt nur in `localStorage` speichern (keine externen Server/APIs).
- Eigenständige HTML-Dateien ohne Build-Tools oder CDN-Abhängigkeiten (muss offline per Doppelklick und via GitHub Pages laufen).

## 2. AES-Prüfungstrainer: Relevanz für den Abschlussjahrgang 2027
Bei allen bestehenden und künftigen Aufgaben, Inhalten und Modulen im **AES-Prüfungstrainer** (`aes/pruefungsvorbereitung/aes-pruefungstrainer/`) muss zwingend geprüft werden, ob sie für die **Realschulabschlussprüfung 2027 in Baden-Württemberg** relevant sind (gemäß amtlichen Ausführungsbestimmungen 2026/2027):

- **Keine ungeprüfte Übernahme alter Aufgaben (2021–2026):** Aufgaben aus Vorjahren dürfen nur genutzt werden, wenn die Inhalte durch die Schwerpunkte 2027 abgedeckt sind.
- **Verbindliche Schwerpunkte für 2027:**
  - **Pflichtteil A:**
    - *Ernährung & Gesundheit:* Gentechnik; Labels (Bioland, demeter, EU-Biosiegel, Naturland, ohne Gentechnik, Fairtrade, Europäisches V-Label, Nutri-Score); Werbeversprechen; Ernährungstrends (Nahrungsergänzungsmittel, vegetarische und vegane Ernährung); Consumer Citizenship.
    - *Lebensgestaltung & Konsum:* Formen des Zusammenlebens; Lebensstil, Konsum und nachhaltige Entwicklung (Ressourcenschonung, Flächennutzungskonkurrenz, Tauschbörsen); Finanzmanagement im privaten Haushalt; Risikoabsicherung (gesetzliche Sozialversicherungen, freiwillige Individualversicherungen: Privathaftpflicht, BU, Hausrat, private Unfallversicherung).
  - **Wahlteil B:**
    - *Lernen durch Engagement:* Bürgerschaftliches Engagement und aktive Teilhabe in der Demokratie.
    - *Ernährung:* Bedarfsgerechte Ernährung, Energie- und Nährstoffträger; Empfehlungen von DGE & BZfE (Stand 2024 / neue Ernährungspyramide mit 2 Milchportionen; 10 DGE-Regeln entfallen); Qualitätsfächer (BZfE); alternative Ernährungsformen.
    - *Gesundheit:* WHO-Definition, persönliche Gesundheitsressourcen & Steigerung, temporäre/permanente Körpergestaltungen, Funktionen von Bekleidung.
    - *Konsum:* Konsumentscheidungen / Werbeversprechen / Marketingstrategien; Qualitätsorientierung; Siegel (Grüner Knopf, Fair Wear Foundation, GOTS, Lebensmittelsiegel); Wertschöpfungskette & globale Handelsbeziehungen (Kinderarbeit, Billigprodukte, Umwelt); Ökologischer Fußabdruck.
    - *Lebensbewältigung:* Formen der Arbeit; Work-Life-Balance / Freizeitgestaltung.
- **Explizit NICHT relevant für 2027 (erst ab 2028 oder früher entfallen):**
  - Funktionelle Lebensmittel, proteinreiche Ernährung (erst ab 2028).
  - Tierwohlsiegel (erst ab 2028).
  - Kreditaufnahme / Überschuldung (erst ab 2028).
  - Medizinische Vorsorgemaßnahmen, Sofortmaßnahmen (erst ab 2028).
  - Stressoren / Stressmanagement (erst ab 2028).
  - Virtuelles Wasser, Recycling (erst ab 2028).
  - Verbraucherrechte / Onlinegeschäfte / Verbraucherschutzinstitutionen (erst ab 2028).

## 3. Git & Datenschutz
- Der Ordner `aes/pruefungsvorbereitung/aes-pruefungstrainer/docs/` enthält urheberrechtlich geschützte Originalprüfungen und ministerielle Bestimmungen und ist in `.gitignore` hinterlegt. Er darf unter keinen Umständen committet oder hochgeladen werden.
