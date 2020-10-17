describe "MambaScript grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-mambascript")

    runs ->
      grammar = atom.syntax.grammarForScopeName("source.mamba")

  it "parses the grammar", ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe "source.mamba"

  it "tokenizes classes", ->
    {tokens} = grammar.tokenizeLine("class Foo")

    expect(tokens[0]).toEqual value: "class", scopes: ["source.mamba", "meta.class.coffee", "storage.type.class.coffee"]
    expect(tokens[1]).toEqual value: " ", scopes: ["source.mamba", "meta.class.coffee"]
    expect(tokens[2]).toEqual value: "Foo", scopes: ["source.mamba", "meta.class.coffee", "entity.name.type.class.coffee"]

    {tokens} = grammar.tokenizeLine("subclass Foo")
    expect(tokens[0]).toEqual value: "subclass Foo", scopes: ["source.mamba"]

    {tokens} = grammar.tokenizeLine("[class Foo]")
    expect(tokens[0]).toEqual value: "[", scopes: ["source.mamba", "meta.brace.square.coffee"]
    expect(tokens[1]).toEqual value: "class", scopes: ["source.mamba", "meta.class.coffee", "storage.type.class.coffee"]
    expect(tokens[2]).toEqual value: " ", scopes: ["source.mamba", "meta.class.coffee"]
    expect(tokens[3]).toEqual value: "Foo", scopes: ["source.mamba", "meta.class.coffee", "entity.name.type.class.coffee"]
    expect(tokens[4]).toEqual value: "]", scopes: ["source.mamba", "meta.brace.square.coffee"]

    {tokens} = grammar.tokenizeLine("bar(class Foo)")
    expect(tokens[0]).toEqual value: "bar", scopes: ["source.mamba"]
    expect(tokens[1]).toEqual value: "(", scopes: ["source.mamba", "meta.brace.round.coffee"]
    expect(tokens[2]).toEqual value: "class", scopes: ["source.mamba", "meta.class.coffee", "storage.type.class.coffee"]
    expect(tokens[3]).toEqual value: " ", scopes: ["source.mamba", "meta.class.coffee"]
    expect(tokens[4]).toEqual value: "Foo", scopes: ["source.mamba", "meta.class.coffee", "entity.name.type.class.coffee"]
    expect(tokens[5]).toEqual value: ")", scopes: ["source.mamba", "meta.brace.round.coffee"]

  it "tokenizes named subclasses", ->
    {tokens} = grammar.tokenizeLine("class Foo extends Bar")

    expect(tokens[0]).toEqual value: "class", scopes: ["source.mamba", "meta.class.coffee", "storage.type.class.coffee"]
    expect(tokens[1]).toEqual value: " ", scopes: ["source.mamba", "meta.class.coffee"]
    expect(tokens[2]).toEqual value: "Foo", scopes: ["source.mamba", "meta.class.coffee", "entity.name.type.class.coffee"]
    expect(tokens[3]).toEqual value: " ", scopes: ["source.mamba", "meta.class.coffee"]
    expect(tokens[4]).toEqual value: "extends", scopes: ["source.mamba", "meta.class.coffee", "keyword.control.inheritance.coffee"]
    expect(tokens[5]).toEqual value: " ", scopes: ["source.mamba", "meta.class.coffee"]
    expect(tokens[6]).toEqual value: "Bar", scopes: ["source.mamba", "meta.class.coffee", "entity.other.inherited-class.coffee"]

  it "tokenizes anonymous subclasses", ->
    {tokens} = grammar.tokenizeLine("class extends Foo")

    expect(tokens[0]).toEqual value: "class", scopes: ["source.mamba", "meta.class.coffee", "storage.type.class.coffee"]
    expect(tokens[1]).toEqual value: " ", scopes: ["source.mamba", "meta.class.coffee"]
    expect(tokens[2]).toEqual value: "extends", scopes: ["source.mamba", "meta.class.coffee", "keyword.control.inheritance.coffee"]
    expect(tokens[3]).toEqual value: " ", scopes: ["source.mamba", "meta.class.coffee"]
    expect(tokens[4]).toEqual value: "Foo", scopes: ["source.mamba", "meta.class.coffee", "entity.other.inherited-class.coffee"]

  it "tokenizes instantiated anonymous classes", ->
    {tokens} = grammar.tokenizeLine("new class")

    expect(tokens[0]).toEqual value: "new", scopes: ["source.mamba", "meta.class.instance.constructor", "keyword.operator.new.coffee"]
    expect(tokens[1]).toEqual value: " ", scopes: ["source.mamba", "meta.class.instance.constructor"]
    expect(tokens[2]).toEqual value: "class", scopes: ["source.mamba", "meta.class.instance.constructor", "storage.type.class.coffee"]

  it "tokenizes instantiated named classes", ->
    {tokens} = grammar.tokenizeLine("new class Foo")

    expect(tokens[0]).toEqual value: "new", scopes: ["source.mamba", "meta.class.instance.constructor", "keyword.operator.new.coffee"]
    expect(tokens[1]).toEqual value: " ", scopes: ["source.mamba", "meta.class.instance.constructor"]
    expect(tokens[2]).toEqual value: "class", scopes: ["source.mamba", "meta.class.instance.constructor", "storage.type.class.coffee"]
    expect(tokens[3]).toEqual value: " ", scopes: ["source.mamba", "meta.class.instance.constructor"]
    expect(tokens[4]).toEqual value: "Foo", scopes: ["source.mamba", "meta.class.instance.constructor", "entity.name.type.instance.coffee"]

    {tokens} = grammar.tokenizeLine("new Foo")

    expect(tokens[0]).toEqual value: "new", scopes: ["source.mamba", "meta.class.instance.constructor", "keyword.operator.new.coffee"]
    expect(tokens[1]).toEqual value: " ", scopes: ["source.mamba", "meta.class.instance.constructor"]
    expect(tokens[2]).toEqual value: "Foo", scopes: ["source.mamba", "meta.class.instance.constructor", "entity.name.type.instance.coffee"]
