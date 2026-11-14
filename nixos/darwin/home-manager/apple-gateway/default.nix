{ lib, ... }:

let
  skillRoot = ./.;
  domainSkillNames = [
    "apple-calendar"
    "apple-clock-alarms"
    "apple-mail"
    "apple-notes"
    "apple-notifications"
    "apple-reminders"
    "apple-schedule"
  ];
  installDomainSkills = lib.concatMapStringsSep "\n" (skillName: ''
    install_skill_file \
      "${skillRoot}/skills/${skillName}/SKILL.md" \
      "$skills_dir/${skillName}/SKILL.md"
    install_skill_file \
      "${skillRoot}/skills/${skillName}/agents/openai.yaml" \
      "$skills_dir/${skillName}/agents/openai.yaml"
  '') domainSkillNames;
in
{
  home.activation.appleGatewaySkill = lib.hm.dag.entryAfter [ "codexSkills" ] ''
    skills_dir="$HOME/.agents/skills"

    install_skill_file() {
      local source_path="$1"
      local target_path="$2"
      local target_dir
      local target_name
      local target_tmp

      target_dir="$(dirname "$target_path")"
      target_name="$(basename "$target_path")"
      target_tmp="$target_dir/.$target_name.tmp.$$"
      mkdir -p "$target_dir"

      if ! cp "$source_path" "$target_tmp"; then
        rm -f "$target_tmp"
        return 1
      fi

      mv -f "$target_tmp" "$target_path"
    }

    install_skill_file \
      "${skillRoot}/SKILL.md" \
      "$skills_dir/apple-gateway/SKILL.md"
    install_skill_file \
      "${skillRoot}/agents/openai.yaml" \
      "$skills_dir/apple-gateway/agents/openai.yaml"

    ${installDomainSkills}
  '';
}
