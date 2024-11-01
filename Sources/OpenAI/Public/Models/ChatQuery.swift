//
//  ChatQuery.swift
//  
//
//  Created by Sergii Kryvoblotskyi on 02/04/2023.
//

import Foundation

/// Creates a model response for the given chat conversation
/// https://platform.openai.com/docs/guides/text-generation
public struct ChatQuery: Equatable, Codable, Streamable {

    /// A list of messages comprising the conversation so far
    public let messages: [Self.ChatCompletionMessageParam]
    /// ID of the model to use. See the model endpoint compatibility table for details on which models work with the Chat API.
    public let model: Model
    /// Number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model's likelihood to repeat the same line verbatim.
    public let frequencyPenalty: Double?
    /// Modify the likelihood of specified tokens appearing in the completion.
    public let logitBias: [String:Int]?
    /// Whether to return log probabilities of the output tokens or not.
    public let logprobs: Bool?
    /// The maximum number of tokens to generate in the completion.
    public let maxTokens: Int?
    /// The maximum number of completion tokens, used for models like o1Preview
    public let maxCompletionTokens: Int?  // New property for o1Preview
    /// How many chat completion choices to generate for each input message.
    public let n: Int?
    /// Number between -2.0 and 2.0. Positive values penalize new tokens based on their appearance in the text so far.
    public let presencePenalty: Double?
    /// An object specifying the format that the model must output.
    public let responseFormat: Self.ResponseFormat?
    /// Seed for deterministic sampling.
    public let seed: Int? // BETA
    /// Up to 4 sequences where the API will stop generating further tokens.
    public let stop: Stop?
    /// Sampling temperature to use, between 0 and 2.
    public let temperature: Double?
    /// Controls which (if any) function is called by the model.
    public let toolChoice: Self.ChatCompletionFunctionCallOptionParam?
    /// A list of tools the model may call.
    public let tools: [Self.ChatCompletionToolParam]?
    /// The number of most likely tokens to return at each token position.
    public let topLogprobs: Int?
    /// Nucleus sampling value, where the model considers the results of the tokens with top_p probability mass.
    public let topP: Double?
    /// A unique identifier representing your end-user.
    public let user: String?
    /// If set, partial message deltas will be sent, like in ChatGPT.
    public var stream: Bool

    public init(
        messages: [Self.ChatCompletionMessageParam],
        model: Model,
        frequencyPenalty: Double? = nil,
        logitBias: [String : Int]? = nil,
        logprobs: Bool? = nil,
        maxTokens: Int? = nil,
        maxCompletionTokens: Int? = nil,  // New initializer parameter
        n: Int? = nil,
        presencePenalty: Double? = nil,
        responseFormat: Self.ResponseFormat? = nil,
        seed: Int? = nil,
        stop: Self.Stop? = nil,
        temperature: Double? = nil,
        toolChoice: Self.ChatCompletionFunctionCallOptionParam? = nil,
        tools: [Self.ChatCompletionToolParam]? = nil,
        topLogprobs: Int? = nil,
        topP: Double? = nil,
        user: String? = nil,
        stream: Bool = false
    ) {
        self.messages = messages
        self.model = model
        self.frequencyPenalty = frequencyPenalty
        self.logitBias = logitBias
        self.logprobs = logprobs
        self.maxTokens = maxTokens
        self.maxCompletionTokens = maxCompletionTokens  // Assign the new property
        self.n = n
        self.presencePenalty = presencePenalty
        self.responseFormat = responseFormat
        self.seed = seed
        self.stop = stop
        self.temperature = temperature
        self.toolChoice = toolChoice
        self.tools = tools
        self.topLogprobs = topLogprobs
        self.topP = topP
        self.user = user
        self.stream = stream
    }

    public enum CodingKeys: String, CodingKey {
        case messages
        case model
        case frequencyPenalty = "frequency_penalty"
        case logitBias = "logit_bias"
        case logprobs
        case maxTokens = "max_tokens"
        case maxCompletionTokens = "max_completion_tokens"
        case n
        case presencePenalty = "presence_penalty"
        case responseFormat = "response_format"
        case seed
        case stop
        case temperature
        case toolChoice = "tool_choice"
        case tools
        case topLogprobs = "top_logprobs"
        case topP = "top_p"
        case user
        case stream
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(messages, forKey: .messages)
        try container.encode(model, forKey: .model)
        try container.encodeIfPresent(frequencyPenalty, forKey: .frequencyPenalty)
        try container.encodeIfPresent(logitBias, forKey: .logitBias)
        try container.encodeIfPresent(logprobs, forKey: .logprobs)
        
        // Conditionally encode maxTokens or maxCompletionTokens
        if let maxCompletionTokens = maxCompletionTokens {
            try container.encode(maxCompletionTokens, forKey: .maxCompletionTokens)
        } else if let maxTokens = maxTokens {
            try container.encode(maxTokens, forKey: .maxTokens)
        }
        
        try container.encodeIfPresent(n, forKey: .n)
        try container.encodeIfPresent(presencePenalty, forKey: .presencePenalty)
        try container.encodeIfPresent(responseFormat, forKey: .responseFormat)
        try container.encodeIfPresent(seed, forKey: .seed)
        try container.encodeIfPresent(stop, forKey: .stop)
        try container.encodeIfPresent(temperature, forKey: .temperature)
        try container.encodeIfPresent(toolChoice, forKey: .toolChoice)
        try container.encodeIfPresent(tools, forKey: .tools)
        try container.encodeIfPresent(topLogprobs, forKey: .topLogprobs)
        try container.encodeIfPresent(topP, forKey: .topP)
        try container.encodeIfPresent(user, forKey: .user)
        try container.encode(stream, forKey: .stream)
    }
}
