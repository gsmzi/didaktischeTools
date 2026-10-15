/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

public void btSpiegleHorizontalClick(GButton source, GEvent event) { //_CODE_:btSpiegleHorizontal:794212:
  if (opHorizontal.isSelected()) {
    bildNeu = spiegleHorizontal(bildAlt);
  } else {
    bildNeu = spiegleVertikal(bildAlt);
  }
  AnzeigenUndMerken(x_start, y_start);
} //_CODE_:btSpiegleHorizontal:794212:

public void btDrehenClick(GButton source, GEvent event) { //_CODE_:btDrehen:314298:
  if (opDreheLinks.isSelected()) {
    bildNeu = dreheLinks(bildAlt);
  } else if (opDreheRechts.isSelected()) {
    bildNeu = dreheRechts(bildAlt);
  }    
  AnzeigenUndMerken(x_start, y_start);
} //_CODE_:btDrehen:314298:

public void btInvertierenClick(GButton source, GEvent event) { //_CODE_:btInvertieren:524942:
  bildNeu = invertiere(bildAlt);
  AnzeigenUndMerken(x_start, y_start);
} //_CODE_:btInvertieren:524942:

public void btGraustufenClick(GButton source, GEvent event) { //_CODE_:btGraustufen:859002:
  if (opMittelwert.isSelected()) {
    bildNeu = graustufenDurchschnitt(bildAlt);
  } else if (opMinimum.isSelected()) {
    bildNeu = graustufenMin(bildAlt);
  } else if (opMaximum.isSelected()) {
    bildNeu = graustufenMax(bildAlt);
  } else if (opNatuerlich.isSelected()) {
    bildNeu = graustufenNatuerlich(bildAlt);
  } else if (opHSB.isSelected()) {
    bildNeu = graustufenHSB(bildAlt);
  }
  AnzeigenUndMerken(x_start, y_start);
} //_CODE_:btGraustufen:859002:

public void btBildLadenClick(GButton source, GEvent event) { //_CODE_:btBildLaden:362917:
  background(255);
  selectInput("Wähle ein Bild:", "fileSelected");
} //_CODE_:btBildLaden:362917:

public void btFaltungClicked(GButton source, GEvent event) { //_CODE_:btFaltung:907937:
  if (opWeichzeichnen.isSelected()) {
    bildNeu = faltung(bildAlt, weichzeichnen);
  } else if (opSchaerfen.isSelected()) {
    bildNeu = faltung(bildAlt, schaerfen);
  } else {
    bildNeu = faltung(bildAlt, relief);
  }
  AnzeigenUndMerken(x_start, y_start);
} //_CODE_:btFaltung:907937:

public void btTauschRGClicked(GButton source, GEvent event) { //_CODE_:btTauschRG:897884:
  bildNeu = tauscheRotGruen(bildAlt);
  AnzeigenUndMerken(x_start, y_start);
} //_CODE_:btTauschRG:897884:

public void btFarbaenderungClicked(GButton source, GEvent event) { //_CODE_:btFarbaenderung:610399:
  bildNeu = farbaenderung(bildAlt, slFaktorRot.getValueF(), slFaktorGruen.getValueF(), slFaktorBlau.getValueF());
  AnzeigenUndMerken(x_start, y_start);
} //_CODE_:btFarbaenderung:610399:

public void slFaktorRotChanged(GSlider source, GEvent event) { //_CODE_:slFaktorRot:988001:
  noStroke();
  rect(lbRot.getX(), lbRot.getY(), lbRot.getWidth(), lbRot.getHeight());
  lbRot.setText(""+Math.round(10.0*slFaktorRot.getValueF())/10.0);
} //_CODE_:slFaktorRot:988001:

public void slFaktorGruenChanged(GSlider source, GEvent event) { //_CODE_:slFaktorGruen:632440:
  noStroke();
  rect(lbGruen.getX(), lbGruen.getY(), lbGruen.getWidth(), lbGruen.getHeight());
  lbGruen.setText(""+Math.round(10.0*slFaktorGruen.getValueF())/10.0);
} //_CODE_:slFaktorGruen:632440:

public void slFaktorBlauChanged(GSlider source, GEvent event) { //_CODE_:slFaktorBlau:377268:
  noStroke();
  rect(lbBlau.getX(), lbBlau.getY(), lbBlau.getWidth(), lbBlau.getHeight());
  lbBlau.setText(""+Math.round(10.0*slFaktorBlau.getValueF())/10.0);
} //_CODE_:slFaktorBlau:377268:

public void btSpeichernClicked(GButton source, GEvent event) { //_CODE_:btSpeichern:713724:
  selectOutput("Dateinamen wählen (.jpg wird automatisch ergänzt):", "fileSelectedSave");
} //_CODE_:btSpeichern:713724:

public void btRueckgaengigClicked(GButton source, GEvent event) { //_CODE_:btRueckgaengig:565159:
  background(255);
  image(bildVorher, x_start, y_start);
  bildAlt = bildVorher;
  schreibeBildinArray(bildAlt);
} //_CODE_:btRueckgaengig:565159:

public void btOriginalClicked(GButton source, GEvent event) { //_CODE_:btOriginal:928763:
  image(bildOriginal, x_start, y_start);
  bildAlt = bildOriginal;
  schreibeBildinArray(bildAlt);
} //_CODE_:btOriginal:928763:

public void btTupfenClick(GButton source, GEvent event) { //_CODE_:btTupfen:311847:
  bildNeu = tupfen(bildAlt, int(tfDurchmesser.getText()), int(tfTupfAnzahl.getText()));
  AnzeigenUndMerken(x_start, y_start);
} //_CODE_:btTupfen:311847:

public void btStrichelnClick(GButton source, GEvent event) { //_CODE_:btStricheln:882489:
  bildNeu = stricheln(bildAlt, int(tfStiftdicke.getText()), int(tfStrichlaenge.getText()), int(tfStrichanzahl.getText()));
  AnzeigenUndMerken(x_start, y_start);
} //_CODE_:btStricheln:882489:

public void btHSBClick(GButton source, GEvent event) { //_CODE_:btHSBFarbaenderung:845799:
  bildNeu = farbaenderungHSB(bildAlt, int(tfHSBFarbton.getText()), int(tfHSBSaettigung.getText()), int(tfHSBHelligkeit.getText()));
  AnzeigenUndMerken(x_start, y_start);
} //_CODE_:btHSBFarbaenderung:845799:

public void btBild2LadenClick(GButton source, GEvent event) { //_CODE_:btBild2Laden:546387:
  selectInput("Wähle ein zweites Bild:", "file2Selected");
} //_CODE_:btBild2Laden:546387:

public void btKombinierenClick(GButton source, GEvent event) { //_CODE_:btKombinieren:320769:
  if (opAddieren.isSelected()) {
    bildKombi = addition(bildAlt, bildZwei);
  } else if (opSubtrahieren.isSelected()) {
    bildKombi = subtraktion(bildAlt, bildZwei);
  } else if (opMultiplizieren.isSelected()) {
    bildKombi = multiplikation(bildAlt, bildZwei);
  }
  image(bildKombi, x_start + bildAlt.width / 2, y_start + bildAlt.height);
} //_CODE_:btKombinieren:320769:

public void btKombiSpeichernClick(GButton source, GEvent event) { //_CODE_:btKombiSpeichern:240511:
  selectOutput("Dateinamen wählen (.jpg wird automatisch ergänzt):", "kombiFileSelectedSave");
} //_CODE_:btKombiSpeichern:240511:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Bildbearbeitung");
  btSpiegleHorizontal = new GButton(this, 1070, 50, 120, 30);
  btSpiegleHorizontal.setText("Bild spiegeln");
  btSpiegleHorizontal.addEventHandler(this, "btSpiegleHorizontalClick");
  grSpiegeln = new GToggleGroup();
  opHorizontal = new GOption(this, 1070, 10, 120, 20);
  opHorizontal.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  opHorizontal.setText("horizontal");
  opHorizontal.setOpaque(false);
  opVertikal = new GOption(this, 1070, 30, 120, 20);
  opVertikal.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  opVertikal.setText("vertikal");
  opVertikal.setOpaque(false);
  grSpiegeln.addControl(opHorizontal);
  opHorizontal.setSelected(true);
  grSpiegeln.addControl(opVertikal);
  grDrehen = new GToggleGroup();
  opDreheLinks = new GOption(this, 1070, 90, 120, 20);
  opDreheLinks.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  opDreheLinks.setText("nach links");
  opDreheLinks.setOpaque(false);
  opDreheRechts = new GOption(this, 1070, 110, 120, 20);
  opDreheRechts.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  opDreheRechts.setText("nach rechts");
  opDreheRechts.setOpaque(false);
  grDrehen.addControl(opDreheLinks);
  opDreheLinks.setSelected(true);
  grDrehen.addControl(opDreheRechts);
  btDrehen = new GButton(this, 1070, 130, 120, 30);
  btDrehen.setText("Bild drehen");
  btDrehen.addEventHandler(this, "btDrehenClick");
  btInvertieren = new GButton(this, 1070, 170, 120, 30);
  btInvertieren.setText("Farben invertieren");
  btInvertieren.addEventHandler(this, "btInvertierenClick");
  grGraustufen = new GToggleGroup();
  opMittelwert = new GOption(this, 1070, 210, 120, 20);
  opMittelwert.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  opMittelwert.setText("Mittelwert");
  opMittelwert.setOpaque(false);
  opMinimum = new GOption(this, 1070, 230, 120, 20);
  opMinimum.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  opMinimum.setText("Minimum");
  opMinimum.setOpaque(false);
  opMaximum = new GOption(this, 1070, 250, 120, 20);
  opMaximum.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  opMaximum.setText("Maximum");
  opMaximum.setOpaque(false);
  opNatuerlich = new GOption(this, 1070, 270, 120, 20);
  opNatuerlich.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  opNatuerlich.setText("Natürlich");
  opNatuerlich.setOpaque(false);
  opHSB = new GOption(this, 1070, 290, 120, 20);
  opHSB.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  opHSB.setText("HSB");
  opHSB.setOpaque(false);
  grGraustufen.addControl(opMittelwert);
  opMittelwert.setSelected(true);
  grGraustufen.addControl(opMinimum);
  grGraustufen.addControl(opMaximum);
  grGraustufen.addControl(opNatuerlich);
  grGraustufen.addControl(opHSB);
  btGraustufen = new GButton(this, 1070, 310, 120, 30);
  btGraustufen.setText("Graustufen");
  btGraustufen.addEventHandler(this, "btGraustufenClick");
  btBildLaden = new GButton(this, 0, 0, 118, 30);
  btBildLaden.setText("Bild laden");
  btBildLaden.addEventHandler(this, "btBildLadenClick");
  grFaltung = new GToggleGroup();
  opWeichzeichnen = new GOption(this, 1070, 360, 120, 20);
  opWeichzeichnen.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  opWeichzeichnen.setText("Weichzeichnen");
  opWeichzeichnen.setOpaque(false);
  opSchaerfen = new GOption(this, 1070, 380, 120, 20);
  opSchaerfen.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  opSchaerfen.setText("Schärfen");
  opSchaerfen.setOpaque(false);
  opRelief = new GOption(this, 1070, 400, 120, 20);
  opRelief.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  opRelief.setText("Relief");
  opRelief.setOpaque(false);
  grFaltung.addControl(opWeichzeichnen);
  opWeichzeichnen.setSelected(true);
  grFaltung.addControl(opSchaerfen);
  grFaltung.addControl(opRelief);
  btFaltung = new GButton(this, 1070, 420, 120, 30);
  btFaltung.setText("Faltung ausführen");
  btFaltung.addEventHandler(this, "btFaltungClicked");
  btTauschRG = new GButton(this, 1070, 460, 120, 30);
  btTauschRG.setText("Tausche Rot - Grün");
  btTauschRG.addEventHandler(this, "btTauschRGClicked");
  btFarbaenderung = new GButton(this, 1070, 650, 120, 30);
  btFarbaenderung.setText("Farbänderung");
  btFarbaenderung.addEventHandler(this, "btFarbaenderungClicked");
  slFaktorRot = new GSlider(this, 1070, 510, 120, 40, 10.0);
  slFaktorRot.setShowLimits(true);
  slFaktorRot.setLimits(1.0, 0.0, 5.0);
  slFaktorRot.setNumberFormat(G4P.DECIMAL, 2);
  slFaktorRot.setOpaque(false);
  slFaktorRot.addEventHandler(this, "slFaktorRotChanged");
  lbRotFaktor = new GLabel(this, 1060, 500, 80, 20);
  lbRotFaktor.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lbRotFaktor.setText("Faktor Rot:");
  lbRotFaktor.setOpaque(false);
  lbRot = new GLabel(this, 1140, 500, 50, 20);
  lbRot.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lbRot.setText("1.0");
  lbRot.setOpaque(false);
  slFaktorGruen = new GSlider(this, 1070, 560, 120, 40, 10.0);
  slFaktorGruen.setShowLimits(true);
  slFaktorGruen.setLimits(1.0, 0.0, 5.0);
  slFaktorGruen.setNumberFormat(G4P.DECIMAL, 2);
  slFaktorGruen.setOpaque(false);
  slFaktorGruen.addEventHandler(this, "slFaktorGruenChanged");
  lbFaktorGruen = new GLabel(this, 1060, 550, 80, 20);
  lbFaktorGruen.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lbFaktorGruen.setText("Faktor Grün: ");
  lbFaktorGruen.setOpaque(false);
  lbGruen = new GLabel(this, 1140, 550, 50, 20);
  lbGruen.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lbGruen.setText("1.0");
  lbGruen.setOpaque(false);
  slFaktorBlau = new GSlider(this, 1070, 610, 120, 40, 10.0);
  slFaktorBlau.setShowLimits(true);
  slFaktorBlau.setLimits(1.0, 0.0, 5.0);
  slFaktorBlau.setNumberFormat(G4P.DECIMAL, 2);
  slFaktorBlau.setOpaque(false);
  slFaktorBlau.addEventHandler(this, "slFaktorBlauChanged");
  lbFaktorBlau = new GLabel(this, 1060, 600, 80, 20);
  lbFaktorBlau.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lbFaktorBlau.setText("Faktor Blau: ");
  lbFaktorBlau.setOpaque(false);
  lbBlau = new GLabel(this, 1140, 600, 50, 20);
  lbBlau.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lbBlau.setText("1.0");
  lbBlau.setOpaque(false);
  btSpeichern = new GButton(this, 120, 0, 110, 30);
  btSpeichern.setText("Bild speichern");
  btSpeichern.addEventHandler(this, "btSpeichernClicked");
  btRueckgaengig = new GButton(this, 300, 0, 160, 30);
  btRueckgaengig.setText("Rückgängig");
  btRueckgaengig.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  btRueckgaengig.addEventHandler(this, "btRueckgaengigClicked");
  btOriginal = new GButton(this, 470, 0, 160, 30);
  btOriginal.setText("Originalbild");
  btOriginal.addEventHandler(this, "btOriginalClicked");
  btTupfen = new GButton(this, 120, 760, 110, 30);
  btTupfen.setText("Bild tupfen");
  btTupfen.addEventHandler(this, "btTupfenClick");
  btStricheln = new GButton(this, 390, 760, 120, 30);
  btStricheln.setText("Bild stricheln");
  btStricheln.addEventHandler(this, "btStrichelnClick");
  label1 = new GLabel(this, 0, 700, 130, 20);
  label1.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label1.setText("Durchmesser Tupfen:");
  label1.setOpaque(false);
  tfDurchmesser = new GTextField(this, 80, 720, 50, 30, G4P.SCROLLBARS_NONE);
  tfDurchmesser.setText("10");
  tfDurchmesser.setOpaque(true);
  label2 = new GLabel(this, 130, 700, 100, 20);
  label2.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label2.setText("Tupfen-Anzahl:");
  label2.setOpaque(false);
  tfTupfAnzahl = new GTextField(this, 180, 720, 50, 30, G4P.SCROLLBARS_NONE);
  tfTupfAnzahl.setText("5000");
  tfTupfAnzahl.setOpaque(true);
  label3 = new GLabel(this, 260, 700, 80, 20);
  label3.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label3.setText("Stiftdicke:");
  label3.setOpaque(false);
  tfStiftdicke = new GTextField(this, 290, 720, 50, 30, G4P.SCROLLBARS_NONE);
  tfStiftdicke.setText("5");
  tfStiftdicke.setOpaque(true);
  label4 = new GLabel(this, 340, 700, 80, 20);
  label4.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label4.setText("Strichlänge:");
  label4.setOpaque(false);
  tfStrichlaenge = new GTextField(this, 370, 720, 50, 30, G4P.SCROLLBARS_NONE);
  tfStrichlaenge.setText("10");
  tfStrichlaenge.setOpaque(true);
  label5 = new GLabel(this, 420, 700, 80, 20);
  label5.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label5.setText("Strichanzahl:");
  label5.setOpaque(false);
  tfStrichanzahl = new GTextField(this, 450, 720, 50, 30, G4P.SCROLLBARS_NONE);
  tfStrichanzahl.setText("5000");
  tfStrichanzahl.setOpaque(true);
  btHSBFarbaenderung = new GButton(this, 760, 760, 120, 30);
  btHSBFarbaenderung.setText("Farbänderung HSB");
  btHSBFarbaenderung.addEventHandler(this, "btHSBClick");
  label6 = new GLabel(this, 530, 700, 110, 20);
  label6.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label6.setText("Änderung Farbton:");
  label6.setOpaque(false);
  tfHSBFarbton = new GTextField(this, 590, 720, 50, 30, G4P.SCROLLBARS_NONE);
  tfHSBFarbton.setText("5");
  tfHSBFarbton.setPromptText(">= 0");
  tfHSBFarbton.setOpaque(true);
  label7 = new GLabel(this, 640, 700, 120, 20);
  label7.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label7.setText("Änderung Sättigung:");
  label7.setOpaque(false);
  tfHSBSaettigung = new GTextField(this, 710, 720, 50, 30, G4P.SCROLLBARS_NONE);
  tfHSBSaettigung.setText("1");
  tfHSBSaettigung.setPromptText("0 bis 2");
  tfHSBSaettigung.setOpaque(true);
  label8 = new GLabel(this, 760, 700, 120, 20);
  label8.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label8.setText("Änderung Helligkeit:");
  label8.setOpaque(false);
  tfHSBHelligkeit = new GTextField(this, 830, 720, 50, 30, G4P.SCROLLBARS_NONE);
  tfHSBHelligkeit.setText("1");
  tfHSBHelligkeit.setPromptText("0 bis 2");
  tfHSBHelligkeit.setOpaque(true);
  btBild2Laden = new GButton(this, 650, 0, 160, 30);
  btBild2Laden.setText("Zweites Bild laden");
  btBild2Laden.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  btBild2Laden.addEventHandler(this, "btBild2LadenClick");
  btKombinieren = new GButton(this, 1070, 750, 120, 30);
  btKombinieren.setText("Bilder kombinieren");
  btKombinieren.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  btKombinieren.addEventHandler(this, "btKombinierenClick");
  grKombination = new GToggleGroup();
  opAddieren = new GOption(this, 1070, 690, 120, 20);
  opAddieren.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  opAddieren.setText("addieren");
  opAddieren.setOpaque(false);
  opSubtrahieren = new GOption(this, 1070, 710, 120, 20);
  opSubtrahieren.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  opSubtrahieren.setText("subtrahieren");
  opSubtrahieren.setOpaque(false);
  opMultiplizieren = new GOption(this, 1070, 730, 120, 20);
  opMultiplizieren.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  opMultiplizieren.setText("multiplizieren");
  opMultiplizieren.setOpaque(false);
  grKombination.addControl(opAddieren);
  opAddieren.setSelected(true);
  grKombination.addControl(opSubtrahieren);
  grKombination.addControl(opMultiplizieren);
  btKombiSpeichern = new GButton(this, 1070, 790, 120, 30);
  btKombiSpeichern.setText("Kombination speichern");
  btKombiSpeichern.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  btKombiSpeichern.addEventHandler(this, "btKombiSpeichernClick");
}

// Variable declarations 
// autogenerated do not edit
GButton btSpiegleHorizontal; 
GToggleGroup grSpiegeln; 
GOption opHorizontal; 
GOption opVertikal; 
GToggleGroup grDrehen; 
GOption opDreheLinks; 
GOption opDreheRechts; 
GButton btDrehen; 
GButton btInvertieren; 
GToggleGroup grGraustufen; 
GOption opMittelwert; 
GOption opMinimum; 
GOption opMaximum; 
GOption opNatuerlich; 
GOption opHSB; 
GButton btGraustufen; 
GButton btBildLaden; 
GToggleGroup grFaltung; 
GOption opWeichzeichnen; 
GOption opSchaerfen; 
GOption opRelief; 
GButton btFaltung; 
GButton btTauschRG; 
GButton btFarbaenderung; 
GSlider slFaktorRot; 
GLabel lbRotFaktor; 
GLabel lbRot; 
GSlider slFaktorGruen; 
GLabel lbFaktorGruen; 
GLabel lbGruen; 
GSlider slFaktorBlau; 
GLabel lbFaktorBlau; 
GLabel lbBlau; 
GButton btSpeichern; 
GButton btRueckgaengig; 
GButton btOriginal; 
GButton btTupfen; 
GButton btStricheln; 
GLabel label1; 
GTextField tfDurchmesser; 
GLabel label2; 
GTextField tfTupfAnzahl; 
GLabel label3; 
GTextField tfStiftdicke; 
GLabel label4; 
GTextField tfStrichlaenge; 
GLabel label5; 
GTextField tfStrichanzahl; 
GButton btHSBFarbaenderung; 
GLabel label6; 
GTextField tfHSBFarbton; 
GLabel label7; 
GTextField tfHSBSaettigung; 
GLabel label8; 
GTextField tfHSBHelligkeit; 
GButton btBild2Laden; 
GButton btKombinieren; 
GToggleGroup grKombination; 
GOption opAddieren; 
GOption opSubtrahieren; 
GOption opMultiplizieren; 
GButton btKombiSpeichern; 
