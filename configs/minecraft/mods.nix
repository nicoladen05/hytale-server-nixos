{ pkgs, ... }:

let
  inherit (pkgs) fetchurl;
in
{
  default = {
    fabric-api = fetchurl {
      url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/gB6TkYEJ/fabric-api-0.140.2%2B1.21.11.jar";
      sha512 = "af4465797d80401021a6aefc8c547200e7c0f8cae134299bf3fafbc310fa81f055246b0614fc0e037538f4a844e55aad30abfa3c67460422853dfc426f086d00";
    };
    ferrite-core = fetchurl {
      url = "https://cdn.modrinth.com/data/uXXizFIs/versions/eRLwt73x/ferritecore-8.0.3-fabric.jar";
      sha512 = "be600543e499b59286f9409f46497570adc51939ae63eaa12ac29e6778da27d8c7c6cd0b3340d8bcca1cc99ce61779b1a8f52b990f9e4e9a93aa9c6482905231";
    };
    lithium = fetchurl {
      url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/gl30uZvp/lithium-fabric-0.21.2%2Bmc1.21.11.jar";
      sha512 = "94625510013e0daaf1c2e2b6d8a463c932ff6220f91ba5b0cd5f868658215f046d94d07b3465660f576c4dc27a5aa183dfbdc1c9303f11894b5b25a1dc6c3bb6";
    };
    no-chat-reports = fetchurl {
      url = "https://cdn.modrinth.com/data/qQyHxfxd/versions/rhykGstm/NoChatReports-FABRIC-1.21.11-v2.18.0.jar";
      sha512 = "d2c35cc8d624616f441665aff67c0e366e4101dba243bad25ed3518170942c1a3c1a477b28805cd1a36c44513693b1c55e76bea627d3fced13927a3d67022ccc";
    };
    scalable-lux = fetchurl {
      url = "https://cdn.modrinth.com/data/Ps1zyz6x/versions/PV9KcrYQ/ScalableLux-0.1.6%2Bfabric.c25518a-all.jar";
      sha512 = "729515c1e75cf8d9cd704f12b3487ddb9664cf9928e7b85b12289c8fbbc7ed82d0211e1851375cbd5b385820b4fedbc3f617038fff5e30b302047b0937042ae7";
    };
  };

  building = {
    axiom = fetchurl {
      url = "https://cdn.modrinth.com/data/N6n5dqoA/versions/M0Jr2ivY/Axiom-5.2.1-for-MC1.21.11.jar";
      sha512 = "00be4c7e6652d8f36855b222effa19a23a532659da932b4321f4f786f169be3d98977e3d4271deb6b415f4692eb87d9a8fd78295a55bbe887771302e64bb1c58";
    };
    world-edit = fetchurl {
      url = "https://cdn.modrinth.com/data/1u6JkXh5/versions/D4snyuU8/worldedit-mod-7.4.0-beta-02.jar";
      sha512 = "887c1f9479ef0d06714c4f842f49568a209f57cc29b21b59373ff8ae5702f65c45b3f5caa442a2cc1b9f0242f93f46706d67b808c30c054eae1e142bc1259fb3";
    };
  };

  cheaty = {
    falling-tree = fetchurl {
      url = "https://cdn.modrinth.com/data/Fb4jn8m6/versions/s7RpQ7ah/FallingTree-1.21.11-1.21.11.2.jar";
      sha512 = "4414f5850297c1b31ab1150d71d7dde44e2132fdaef4b286df8785be9f975e98c45317bba7a22fb1612f287dfebe875b7b69444a151a64cb64dd38c4f7b433f9";
    };
    infinite-trade = fetchurl {
      url = "https://cdn.modrinth.com/data/U3eoZT3o/versions/QmTnAQac/infinitetrading-1.21.11-4.6.jar";
      sha512 = "03dd37e306b71c0588d89b395f4862e80deedaca4facbda721052d346e56f5385f88bd56382fc5cbeb3a91488f2dd33446612c32392b677f9a1f057edb2d78e8";
    };
    collective = fetchurl {
      url = "https://cdn.modrinth.com/data/e0M1UDsY/versions/T8rv7kwo/collective-1.21.11-8.13.jar";
      sha512 = "af145a48ac89346c7b1ffa8c44400a91a9908e4d1df0f6f1a603ff045b1fd82d9aa041aea27a682c196b266c0daf84cb5b7b8d83b07ee53e2bc1a5c210d19a1b";
    };
  };
}
