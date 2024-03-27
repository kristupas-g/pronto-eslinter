# frozen_string_literal: true

RSpec.describe Pronto::Eslinter::Eslint, '#lint' do
  subject do
    described_class.new(files).lint
  end

  let(:files) ['some/file.js']
  let(:output) do
    <<~HEREDOC

      Packages: +99
      +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Progress: resolved 99, reused 99, downloaded 0, added 99, done
      [ { "filePath": "/Users/kristupas.gaidys/vinted/core/client/app/types/ui.ts", "messages": [ { "ruleId": "no-console", "severity": 1, "message": "Unexpected console statement.", "line": 1, "column": 11, "nodeType": "MemberExpression", "messageId": "unexpected", "endLine": 1, "endColumn": 22, "suggestions": [ { "messageId": "removeConsole", "data": { "propertyName": "log" }, "fix": { "range": [10, 55], "text": "" }, "desc": "Remove the console.log()." } ] } ], "suppressedMessages": [], "errorCount": 3, "fatalErrorCount": 0, "warningCount": 1, "fixableErrorCount": 2, "fixableWarningCount": 0, "source": "if(x==y) {console.log(\"missing spaces around operator\")}\n\nexport type VintedTheme =\n  | 'primary'\n  | 'muted'\n  | 'success'\n  | 'warning'\n  | 'expose'\n  | 'amplified'\n  | 'transparent'\n  | 'inverse'\n  | 'inherit'\n", "usedDeprecatedRules": [ ] } ]
    HEREDOC
  end

  before do
    allow(Kernel).to receive(:`).and_return(output)
  end

  it 'returns parsed json output' do
    puts subject
    #expect(subject).to eq()
  end
end
