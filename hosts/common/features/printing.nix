# CUPS with the HP LaserJet Pro M12w on the home network (driverless: AirPrint/IPP Everywhere).
{ ... }:
{
  services.printing.enable = true;

  hardware.printers = {
    ensurePrinters = [
      {
        name = "LaserJet_M12w";
        description = "HP LaserJet Pro M12w";
        deviceUri = "ipp://NPI4D9389.fritz.box/ipp/print";
        model = "everywhere"; # CUPS builds the driver from what the printer reports
      }
    ];
    ensureDefaultPrinter = "LaserJet_M12w";
  };
}
