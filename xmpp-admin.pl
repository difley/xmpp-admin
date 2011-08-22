# xmpp-admin.pl
#copy into .irssi/scripts
#load in irssi with: /script load xmpp-admin
use Irssi;

$::VERSION='0.0.1';
%::IRSSI = (
    authors => 'Seth Difley',
    contact => '',
    name => 'xmpp-admin',
    description => 'Adds admin commands to irssi-xmpp',
    url => '',
    license => 'GNU General Public License',
    changed => '$Date$'
    );

#/affiliate affiliation_level [jid]
#If jid is absent, the affiliation list is returned (Raw xml messages must be active to see the list.)
sub cmd_affiliate {
    my ($data,$server,$wid) = @_;
    @items = split(" ", $data);
    if ($items[0]) {
        if ($items[1]) {
            $affil = "QUOTE <iq type=\'set\' id=\'affiliate_set\' to=\'$wid->{name}\'> <query xmlns=\'http://jabber.org/protocol/muc#admin\'> <item jid=\'$items[1]\' affiliation=\'$items[0]\'/> </query> </iq>";
        }
        else {
            $affil = "QUOTE <iq type=\'get\' id=\'affiliate_get\' to=\'$wid->{name}\'> <query xmlns=\'http://jabber.org/protocol/muc#admin\'> <item affiliation=\'$items[0]\'/> </query> </iq>";
        }
        $server->command("$affil");
    }
    else {
        Irssi::active_win()->print("/affiliate none|owner|admin|member|outcast [jid]");
    }
}

#/role role_level nickname [reason]
sub cmd_role {
    my ($data,$server,$wid) = @_;
    @items = split(" ", $data);
    if ($items[1]) {
        if ($items[2]) {
            $data =~ s/^.*?[\s]+.*?[\s]+//;
            $reason = "<reason>$data</reason>";
        }
        else {
            $reason = "";
        }
        $role = "QUOTE <iq type=\'set\' id=\'role_set\' to=\'$wid->{name}\'> <query xmlns=\'http://jabber.org/protocol/muc#admin\'> <item nick=\'$items[1]\' role=\'$items[0]\'> $reason </item> </query> </iq>";
        $server->command("$role");
    }
    else {
        Irssi::active_win()->print("/role none|moderator|participant|visitor nickname [reason]");
    }
}

#/kick nickname [reason]
sub cmd_kick {
    my ($data,$server,$wid) = @_;
    @items = split(" ", $data);
    if ($items[0]) {
        cmd_role("none " . $data,$server,$wid);
    }
    else {
        Irssi::active_win()->print("/kick nickname [reason]");
    }
}

Irssi::command_bind('affiliate', \&cmd_affiliate);
Irssi::command_bind('role', \&cmd_role);
Irssi::command_bind('kick', \&cmd_kick);
